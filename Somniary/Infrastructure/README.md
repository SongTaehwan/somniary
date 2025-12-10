# Infrastructure

## 목적

외부 시스템과의 통신 및 저수준 기술 구현을 담당하는 레이어

- 외부 API 서버와의 HTTP 통신
- 데이터베이스 접근 (CoreData, Realm 등)
- 파일 시스템, 로컬 저장소 접근
- 외부 프레임워크 및 라이브러리와의 직접 상호작용

## 아키텍처 원칙

1. **Framework 종속성 허용**: 외부 라이브러리(Alamofire, CoreData 등) 직접 사용
2. **전송 계층 에러**: Infrastructure 고유의 에러 타입 정의 (TransportError 등)
3. **DTO 사용**: 외부 시스템의 데이터 구조를 나타내는 DTO(Data Transfer Object)
4. **Domain 격리**: Domain 타입을 직접 참조하지 않음 (Data 레이어에서 매핑)

## 레이어 구조

```
Infrastructure/
└── Network/              # HTTP 통신 인프라
    ├── Interfaces/       # 프로토콜 정의
    │   ├── Endpoint.swift
    │   ├── SomniaryEndpoint.swift
    │   └── SomniaryNetworking.swift
    ├── Endpoints/        # API 엔드포인트 정의
    │   ├── AuthEndpoint.swift
    │   ├── DiaryEndpoint.swift
    │   └── UserEndpoint.swift
    ├── Entities/         # Network DTO
    │   ├── Auth/
    │   ├── Diary/
    │   └── Profile/
    ├── SomniaryHTTPClient.swift    # HTTP 클라이언트 구현
    ├── TransportError.swift        # 전송 계층 에러
    └── NetworkClientProvider.swift # 클라이언트 제공자
```

**향후 확장 가능 구조:**

```
Infrastructure/
├── Network/        # HTTP 통신
├── WebSocket/      # 실시간 양방향 통신
├── Storage/        # 로컬 데이터베이스 (CoreData, Realm)
└── FileSystem/     # 파일 시스템 접근
```

## 의존성 규칙

```
Infrastructure/Network → Foundation, Combine, Alamofire
Data (DataSource)      → Infrastructure
Domain                 → ❌ Infrastructure (직접 참조 금지)
```

**금지 사항:**

- Infrastructure → Domain (Domain 타입 참조 금지)
- Infrastructure → Data (상위 레이어 참조 금지)
- Infrastructure → Presentation (상위 레이어 참조 금지)

**허용 사항:**

- Infrastructure → Foundation (Apple 표준 프레임워크)
- Infrastructure → Common (독립 모듈)
- Infrastructure → 외부 라이브러리 (Alamofire, Kingfisher 등)

## Clean Architecture에서의 역할

```
Presentation (View, ViewModel)
    ↓
Domain (UseCase, Repository Interface, Entity)
    ↓
Data (Repository 구현, DataSource)
    ↓  ← 에러 매핑, DTO → Entity 변환
Infrastructure (Network, Database)
    ↓
Framework (Alamofire, CoreData, URLSession)
```

**핵심 원칙:**

- Infrastructure는 기술 구현에만 집중
- 비즈니스 로직은 포함하지 않음
- Domain과의 직접적인 의존성 없음
- Data 레이어에서 Infrastructure 에러를 Domain 에러로 매핑

## Network 서브레이어

### Interfaces

네트워크 통신을 위한 프로토콜 정의

```swift
// Network/Interfaces/SomniaryNetworking.swift
protocol SomniaryNetworking<Target> {
    associatedtype Target: SomniaryEndpoint

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError>
}
```

**특징:**

- HTTP 클라이언트의 인터페이스 정의
- 테스트 시 모킹 가능한 추상화
- Alamofire 등 구체적 구현과 분리

### Endpoints

API 엔드포인트 정의 (URL, Method, Headers, Payload)

```swift
// Network/Endpoints/AuthEndpoint.swift
enum AuthEndpoint: SomniaryEndpoint {
    case login(email: String)
    case logout

    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .logout: return "/auth/logout"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .logout: return .delete
        }
    }
}
```

**특징:**

- RESTful API 엔드포인트를 타입으로 표현
- 컴파일 타임에 잘못된 요청 방지
- 엔드포인트별 요청 구성 캡슐화

### Entities (Network DTO)

외부 API 응답 데이터 구조

```swift
// Network/Entities/Auth/NetAuth.swift
struct NetAuth: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String
}
```

**특징:**

- 서버 응답 JSON 구조를 그대로 반영
- `Decodable`/`Encodable` 프로토콜 채택
- Domain Entity와는 별개의 타입 (Data 레이어에서 변환)
- API 스펙 변경에 대한 충격 흡수

**DTO → Entity 변환 예시:**

```swift
// Data/DataSources/RemoteAuthDataSource.swift
func login(email: String) async -> Result<AuthToken, DataSourceError> {
    let result = await client.request(.login(email: email))

    return result.flatMap { response in
        // 1. DTO 디코딩
        let netAuth = try? JSONDecoder().decode(NetAuth.self, from: response.body)

        // 2. DTO → Entity 변환
        let authToken = AuthToken(
            accessToken: netAuth.accessToken,
            refreshToken: netAuth.refreshToken
        )
        return .success(authToken)
    }
}
```

### TransportError

전송 계층의 에러 타입

```swift
// Network/TransportError.swift
/// 전송 성공 여부가 에러를 가르는 기준
/// 네트워크 프로토콜에 대한 해석은 Data Source
enum TransportError: Error, Equatable {
    /// 네트워크 연결 관련 오류
    case network(Network)

    /// Request 생성 오류
    case requestBuildFailed

    /// SSL/TLS 문제
    case tls

    /// 전송 요청 취소
    case cancelled

    case unknown

    enum Network: Equatable {
        case offline
        case timeout
        case dnsLookupFailed
        case connectionLost
        case redirectLoop
        case other(URLError.Code)
    }
}
```

**특징:**

- 전송 계층(Transport Layer)의 에러만 표현
- HTTP 상태 코드 해석은 Data 레이어 책임
- Alamofire, URLSession 에러를 TransportError로 매핑
- Data 레이어에서 TransportError → DomainError 매핑

**에러 매핑 흐름:**

```
URLError/AFError (Infrastructure)
    ↓ SomniaryHTTPClient
TransportError (Infrastructure)
    ↓ DataSource
DataSourceError (Data)
    ↓ Repository
DomainError (Domain)
```

### SomniaryHTTPClient

HTTP 클라이언트 구현체

```swift
// Network/SomniaryHTTPClient.swift
final class SomniaryHTTPClient<Target: SomniaryEndpoint>: SomniaryNetworking {
    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError> {
        // Alamofire Session 사용하여 요청 수행
        // URLError/AFError → TransportError 매핑
    }
}
```

**특징:**

- `SomniaryNetworking` 프로토콜 구현
- Alamofire `Session`을 래핑
- 프레임워크 에러를 TransportError로 변환
- 로깅, 인터셉터 등 공통 처리

## 추가 기준

새로운 Infrastructure 코드 추가 시 다음을 확인:

**Network 추가 시:**

- [ ] 외부 API 통신과 관련된 코드인가?
- [ ] Domain 타입에 직접 의존하지 않는가?
- [ ] 전송 계층의 관심사인가? (HTTP, 네트워크 연결 등)
- [ ] Data 레이어의 DataSource에서 사용될 코드인가?

**Endpoint 추가 시:**

- [ ] RESTful API 엔드포인트 정의인가?
- [ ] 요청에 필요한 정보(URL, Method, Payload)가 모두 포함되어 있는가?
- [ ] 타입 안전성을 보장하는가?

**Network DTO 추가 시:**

- [ ] 서버 API 응답/요청 구조를 표현하는가?
- [ ] `Codable` 프로토콜을 채택하는가?
- [ ] Domain Entity와 분리되어 있는가?
- [ ] API 스펙 변경 시 영향을 격리할 수 있는가?

**TransportError 확장 시:**

- [ ] 전송 계층의 에러인가? (HTTP 상태 코드 에러는 Data 레이어)
- [ ] 재시도 정책, 사용자 안내 등 에러 대응에 필요한 정보가 충분한가?
- [ ] 다른 TransportError 케이스와 중복되지 않는가?

## 파일 명명 규칙

**Endpoint:**

- `서비스명Endpoint.swift` (예: `AuthEndpoint.swift`, `DiaryEndpoint.swift`)

**Network DTO:**

- `Net<Entity명>.swift` (예: `NetAuth.swift`, `NetDiary.swift`)
- 요청/응답별 구분: `Net<Entity명>+<Action>.swift` (예: `NetAuth+Verify.swift`)

**Client:**

- `<서비스명>HTTPClient.swift` 또는 `<서비스명>Networking.swift`

**Error:**

- `<기술명>Error.swift` (예: `TransportError.swift`, `DatabaseError.swift`)

## 레이어 사용 가이드

### Data 레이어에서 Infrastructure 사용

```swift
// Data/DataSources/RemoteAuthDataSource.swift
final class RemoteAuthDataSource {
    private let client: SomniaryHTTPClient<AuthEndpoint>

    func login(email: String) async -> Result<AuthToken, DataSourceError> {
        // 1. Infrastructure 레이어 호출
        let result = await client.request(.login(email: email))

        // 2. HTTP 상태 코드 해석 (Data 레이어 책임)
        // 3. DTO 디코딩
        // 4. DTO → Entity 변환
        // 5. TransportError → DataSourceError 매핑

        return result
            .flatMap { /* DTO → Entity */ }
            .mapError { /* TransportError → DataSourceError */ }
    }
}
```

**책임 분리:**

- Infrastructure: 전송만 담당 (TransportError)
- Data: HTTP 해석, DTO 변환, 에러 매핑 (DataSourceError)
- Domain: 비즈니스 로직 (DomainError)

### 테스트에서 Infrastructure 모킹

```swift
// Tests/Mocks/MockHTTPClient.swift
final class MockHTTPClient<Target: SomniaryEndpoint>: SomniaryNetworking {
    var mockResult: Result<HTTPResponse, TransportError>!

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError> {
        return mockResult
    }
}

// Tests/DataSources/RemoteAuthDataSourceTests.swift
func testLoginSuccess() async {
    // Given
    let mockClient = MockHTTPClient<AuthEndpoint>()
    mockClient.mockResult = .success(mockHTTPResponse)
    let dataSource = RemoteAuthDataSource(client: mockClient)

    // When
    let result = await dataSource.login(email: "test@example.com")

    // Then
    XCTAssertTrue(result.isSuccess)
}
```

## Anti-corruption Layer (ACL)

Infrastructure와 Domain 사이의 격리를 위해 Data 레이어가 ACL 역할 수행

**변환 책임:**

- DTO → Entity (Infrastructure → Domain)
- TransportError → DomainError (Infrastructure → Domain)
- Entity → DTO (Domain → Infrastructure, 필요시)

**예시:**

```swift
// Data/Repositories/RemoteAuthRepository.swift
final class RemoteAuthRepository: AuthRepository {
    private let dataSource: RemoteAuthDataSource

    func login(email: String) async -> Result<AuthToken, DomainError> {
        let result = await dataSource.login(email: email)

        // DataSourceError → DomainError 매핑 (ACL)
        return result.mapError { error in
            switch error {
            case .networkUnavailable: return .connectivity(.offline)
            case .httpError(let status): return .server(.httpStatus(status))
            default: return .unknown
            }
        }
    }
}
```

## Clean Architecture 준수 체크리스트

- [ ] Infrastructure는 Domain을 직접 참조하지 않는가?
- [ ] DTO와 Entity가 분리되어 있는가?
- [ ] 에러 매핑이 레이어별로 명확히 구분되는가?
- [ ] 비즈니스 로직이 Infrastructure에 포함되어 있지 않은가?
- [ ] 프레임워크 변경 시 Domain/Data 레이어 영향이 최소화되는가?
- [ ] 테스트 시 Infrastructure 전체를 모킹 가능한가?
