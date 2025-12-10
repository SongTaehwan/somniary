## Domain

### 목적

애플리케이션의 핵심 비즈니스 로직과 도메인 규칙을 정의하는 레이어

- 비즈니스 엔티티와 유스케이스 정의
- 도메인 에러 처리 및 에러 타입 정의
- 외부 레이어(Infrastructure, Presentation)에 독립적인 순수 비즈니스 로직

### 아키텍처 원칙

1. **의존성 역전**: Domain은 다른 레이어에 의존하지 않음
2. **순수성**: 외부 프레임워크나 라이브러리에 의존하지 않음 (Foundation만 사용)
3. **도메인 중심**: 비즈니스 규칙과 엔티티가 중심
4. **인터페이스 정의**: Repository, UseCase 등의 인터페이스 정의 (구현은 Data/Presentation 레이어)

### 레이어 구조

```
Domain/
├── Entities/          # 비즈니스 엔티티 (도메인 모델)
├── UseCases/         # 비즈니스 유스케이스 (인터페이스)
├── Models/           # UseCase Input/Output 모델
├── Utils/            # Domain 전용 유틸리티
└── Errors/           # 도메인 에러 타입 및 에러 처리
```

### 의존성 규칙

```
Domain → Foundation (시스템 프레임워크만)
```

**금지 사항:**

- Domain → Core
- Domain → Data/Infrastructure 레이어
- Domain → Presentation 레이어
- Domain → Common or Helpers

### 하위 모듈 설명

#### Entities

- 비즈니스 도메인의 핵심 개념을 표현하는 순수 데이터 구조
- 프로젝트 특화 비즈니스 엔티티 (예: User, Diary, SleepRecord 등)

**Extension 작성 규칙:**

- 비즈니스 로직/도메인 규칙 → Entity 내부 또는 Domain 내 별도 파일
- 프레젠테이션/기술 지원 → Helpers에 extension으로 분리

```swift
// Domain/Entities/User.swift - 비즈니스 로직
struct User {
    var canPublishDiary: Bool { isActive && isVerified }
}

// Helpers/User+Extensions.swift - 프레젠테이션 지원
extension User {
    var displayName: String { ... }
    func toDTO() -> UserDTO { ... }
}
```

#### UseCases

- 비즈니스 로직의 실행 단위
- Repository 인터페이스를 통해 데이터 접근 (구현체는 Data 레이어)
- 단일 책임 원칙에 따라 각 유스케이스는 하나의 비즈니스 작업만 수행

#### Models

- UseCase의 Input(Query/Command)과 Output(Result) 전용 모델
- Entity와 외부 레이어(Presentation/Data) 간 경계 역할
- 필요한 데이터만 포함하여 레이어 간 컨텍스트 최소화

**Entity vs Models 구분:**

| 구분      | Entity               | Models (Input/Output)           |
| --------- | -------------------- | ------------------------------- |
| 목적      | 비즈니스 규칙 표현   | UseCase 데이터 전송             |
| 범위      | 모든 도메인 속성     | UseCase별 필요 데이터만         |
| 변경 빈도 | 낮음 (비즈니스 규칙) | 높음 (UseCase 요구사항)         |
| 사용처    | Domain 내부          | Domain ↔ 외부 레이어 경계       |
| 예시      | `User`, `Diary`      | `LoginRequest`, `DiaryListItem` |

**Query vs Command 구분 (CQRS):**

| 구분      | Query               | Command                                      |
| --------- | ------------------- | -------------------------------------------- |
| 목적      | 데이터 조회 (읽기)  | 데이터 변경 (쓰기)                           |
| 상태 변경 | 없음                | 있음                                         |
| 반환값    | 데이터 반환         | 성공/실패 또는 생성된 ID                     |
| 예시      | `GetDiaryListQuery` | `CreateDiaryCommand`                         |
| UseCase   | `GetXxxUseCase`     | `CreateXxx`, `UpdateXxx`, `DeleteXxxUseCase` |

```swift
// Query - 읽기 작업 (상태 변경 없음)
struct GetDiaryListQuery {
    let userId: String
    let dateRange: DateRange?
    let limit: Int
}

protocol GetDiaryListUseCase {
    func execute(_ query: GetDiaryListQuery) async -> Result<[DiaryListItem], DomainError>
}

// Command - 쓰기 작업 (상태 변경)
struct CreateDiaryCommand {
    let userId: String
    let content: String
    let mood: Mood
}

protocol CreateDiaryUseCase {
    func execute(_ command: CreateDiaryCommand) async -> Result<DiaryId, DomainError>
}
```

**네이밍 규칙:**

- Query Input: `Get{Entity}Query`, `Fetch{Entity}Query`, `Search{Entity}Query`
- Command Input: `Create{Entity}Command`, `Update{Entity}Command`, `Delete{Entity}Command`
- Output: `{Entity}Item`, `{Entity}Summary`, `{Entity}Result`, `{UseCase}Response`
- UseCase: `{동사}{Entity}UseCase` (예: `GetDiaryListUseCase`, `CreateDiaryUseCase`)

**작성 예시:**

```swift
// Entity - 풍부한 비즈니스 모델
struct Diary {
    let id: String
    let content: String
    let privateNotes: String  // 민감 정보
    let mood: Mood
    let createdAt: Date
    let tags: [Tag]

    // 비즈니스 규칙
    var canBeShared: Bool {
        !content.isEmpty && privateNotes.isEmpty
    }
}

// Query Input - 조회 작업 (UseCase Input)
struct GetDiaryListQuery {
    let userId: String
    let dateRange: DateRange?
    let limit: Int
    let offset: Int
}

// Query Output - Entity에서 필요한 데이터만 추출 (UseCase Output)
struct DiaryListItem {
    let id: String
    let previewText: String  // content의 일부만
    let mood: Mood
    let date: Date

    init(from diary: Diary) {
        self.id = diary.id
        self.previewText = String(diary.content.prefix(100))
        self.mood = diary.mood
        self.date = diary.createdAt
    }
}

// Query UseCase (UseCase Input)
protocol GetDiaryListUseCase {
    func execute(_ query: GetDiaryListQuery) async -> Result<[DiaryListItem], DomainError>
}

// Command Input - 생성 작업 (UseCase Input)
struct CreateDiaryCommand {
    let userId: String
    let content: String
    let mood: Mood
    let tags: [String]
}

// Command Output - 생성된 리소스 식별자 (UseCase Output)
struct DiaryId {
    let value: String
}

// Command UseCase
protocol CreateDiaryUseCase {
    func execute(_ command: CreateDiaryCommand) async -> Result<DiaryId, DomainError>
}

// Command Input - 수정 작업 (UseCase Input)
struct UpdateDiaryCommand {
    let diaryId: String
    let content: String?
    let mood: Mood?
}

// Command UseCase
protocol UpdateDiaryUseCase {
    func execute(_ command: UpdateDiaryCommand) async -> Result<Void, DomainError>
}
```

**Models 사용 이유:**

- View가 Entity의 민감 정보에 접근 방지
- Entity 변경이 모든 레이어에 전파되는 것 방지
- UseCase별로 필요한 데이터만 노출 (최소 권한 원칙)
- 레이어 간 경계를 명확히 하여 결합도 감소

#### Utils

- Domain 레이어에서만 사용되는 유틸리티 함수 및 확장
- 비즈니스 로직을 지원하는 헬퍼 함수
- DomainError 등 Domain 타입에 의존 가능

**포함 대상:**

- 비즈니스 규칙 검증 함수
- Domain 타입(DomainError, Entity 등)의 확장
- 복잡한 비즈니스 로직을 지원하는 헬퍼 함수
- Domain Entity 컬렉션에 대한 유틸리티

**제외 대상:**

- 순수 Foundation 확장 (→ Foundation 레이어)
- Presentation 지원 코드 (→ Helpers)
- 독립 재사용 모듈 (→ Common)

**작성 예시:**

```swift
// Domain/Utils/Result+Domain.swift
extension Result where Failure == DomainError {
    /// Repository 호출 시 에러 매핑
    static func fromRepository<T>(
        _ body: () async throws -> T
    ) async -> Result<T, DomainError> where Success == T {
        do {
            return .success(try await body())
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(DomainError.unknown(error))
        }
    }
}

// Domain/Utils/Collection+Domain.swift
extension Collection where Element: Entity {
    /// 비즈니스 규칙: 활성 상태인 엔티티만 필터링
    func onlyActive() -> [Element] {
        filter { $0.isActive }
    }
}

// Domain/Utils/DomainHelpers.swift
enum DomainValidation {
    /// 비즈니스 규칙: 날짜 범위 검증
    static func validateDateRange(
        _ start: Date,
        _ end: Date
    ) -> Result<Void, DomainError> {
        guard start < end else {
            return .failure(DomainError.invalidDateRange)
        }
        guard end <= Date() else {
            return .failure(DomainError.futureDate)
        }
        return .success(())
    }
}
```

#### Errors

- 도메인 에러 타입 정의 (`DomainError` 프로토콜)
- 에러 분류 및 구조화 (`ErrorDescriptor`, `ErrorContext`)
- 에러 심각도 및 사용자 메시지 정의

### 에러 처리 원칙

1. **도메인 에러 타입**: `DomainError` 프로토콜을 채택한 에러만 사용
2. **에러 매핑**: Infrastructure 레이어의 에러는 Repository에서 Domain 에러로 변환
3. **에러 컨텍스트**: `ErrorContext`를 통해 에러 발생 지점 및 메타데이터 보존
4. **에러 디스크립터**: `ErrorDescriptor`를 통해 에러 분류 및 사용자 메시지 정의

### 추가 기준

새로운 도메인 요소 추가 시 다음을 확인:

**Entity 추가 시:**

- [ ] 비즈니스 규칙과 개념을 표현하는가?
- [ ] 도메인 전문가가 이해 가능한가?
- [ ] 다른 레이어에 의존하지 않는가? (Foundation 제외)

**Models 추가 시:**

- [ ] 특정 UseCase의 Input 또는 Output인가?
- [ ] Query(조회)와 Command(변경)를 명확히 구분했는가?
- [ ] Entity의 모든 속성이 아닌 필요한 데이터만 포함하는가?
- [ ] 외부 레이어에 과도한 컨텍스트를 노출하지 않는가?
- [ ] 네이밍 규칙을 따르는가? (Query/Command 접미사)

**UseCase 추가 시:**

- [ ] 단일 비즈니스 작업만 수행하는가?
- [ ] Input/Output 모델을 통해 경계가 명확한가?
- [ ] Repository 인터페이스를 통해 데이터에 접근하는가?

**Utils 추가 시:**

- [ ] Domain 레이어에서만 사용되는가?
- [ ] 비즈니스 로직을 지원하는가?
- [ ] Domain 타입(DomainError, Entity 등)에 의존하는가?
- [ ] 순수 Foundation 확장이 아닌가? (순수 확장은 Foundation 레이어)

**공통:**

- [ ] 외부 프레임워크/라이브러리에 의존하지 않는가?
- [ ] 테스트 가능한가?
