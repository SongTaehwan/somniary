## Helpers

### 목적

Presentation 및 Data 레이어를 지원하는 프로젝트 특화 확장 및 유틸리티

- Domain Entity의 외부 레이어 지원용 확장
- Presentation 레이어를 위한 UI 지원 코드
- Data 레이어를 위한 DTO 변환 코드
- 프로젝트 컨텍스트에서만 의미 있는 코드

### 아키텍처 원칙

1. **프로젝트 특화**: 앱의 비즈니스 로직을 지원하는 헬퍼
2. **도메인 의존**: Domain, Presentation 레이어에서 사용되는 확장/유틸리티
3. **Common과 구분**: 독립 재사용이 목적이 아닌, 프로젝트 컨텍스트 내에서 사용
4. **단방향 참조**: Core, Domain, Common은 참조 가능하나 역방향 참조 금지

### 의존성 규칙

```
Helpers → Foundation (순수 확장)
Helpers → Core (아키텍처 인터페이스)
Helpers → Domain (비즈니스 엔티티)
Helpers → Common (독립 유틸리티)
```

**사용처:**

- Presentation Layer (ViewModel, Views)
- Data Layer (Repository 구현체)

### 레이어별 유틸리티 구분

| 레이어 | Foundation           | Domain/Utils             | Helpers                    |
| ------ | -------------------- | ------------------------ | -------------------------- |
| 목적   | 순수 Foundation 확장 | Domain 전용 유틸리티     | Presentation/Data 지원     |
| 의존성 | Foundation만         | Foundation, Domain 타입  | Foundation, Domain, Common |
| 사용처 | 모든 레이어          | Domain 레이어만          | Presentation, Data 레이어  |
| 예시   | `Result.catching`    | `Result<T, DomainError>` | `Diary.previewText`        |
| 재사용 | 프로젝트 독립적      | 프로젝트 내 Domain만     | 프로젝트 내 외부 레이어    |

### Presentation/Data 레이어 지원

Helpers는 Domain Entity 를 외부 레이어에서 사용하기 쉽게 만드는 역할을 합니다.

#### Presentation 레이어 지원

**UI 표시용 확장:**

```swift
// Helpers/Diary+Presentation.swift
import Domain

extension Diary {
    /// UI에 표시할 미리보기 텍스트
    var previewText: String {
        String(content.prefix(100))
    }

    /// UI에 표시할 포맷팅된 날짜
    var formattedDate: String {
        createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    /// UI에 표시할 감정 이모지
    var moodEmoji: String {
        switch mood {
        case .happy: return "😊"
        case .sad: return "😢"
        case .angry: return "😠"
        }
    }
}
```

**ViewModel 지원:**

```swift
// Helpers/User+Presentation.swift
extension User {
    /// 사용자 표시명 (이메일 앞부분)
    var displayName: String {
        email.components(separatedBy: "@").first ?? "Unknown"
    }

    /// 프로필 이미지 URL
    var avatarURL: URL? {
        URL(string: "https://api.example.com/avatar/\(id)")
    }
}
```

#### Data 레이어 지원

**DTO 변환:**

```swift
// Helpers/Diary+DTO.swift
import Domain

extension Diary {
    /// Network 전송용 DTO로 변환
    func toNetworkDTO() -> DiaryDTO {
        DiaryDTO(
            id: id,
            content: content,
            mood: mood.rawValue,
            tags: tags.map { $0.name },
            createdAt: createdAt.ISO8601Format()
        )
    }

    /// Network DTO에서 Entity 생성
    static func from(dto: DiaryDTO) -> Diary {
        Diary(
            id: dto.id,
            content: dto.content,
            mood: Mood(rawValue: dto.mood) ?? .neutral,
            tags: dto.tags.map { Tag(name: $0) },
            createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? Date()
        )
    }
}
```

**Repository 지원:**

```swift
// Helpers/TokenRepository+Extensions.swift
import Common

extension TokenRepository {
    /// 액세스 토큰 존재 여부 확인
    var hasValidToken: Bool {
        getAccessToken() != nil
    }
}
```

### Extension for Domain Entity 가이드

Domain Entity 에 기능을 추가할 때 다음 기준으로 위치를 결정:

**비즈니스 로직 → Domain 내부**

- 도메인 규칙과 검증
- 비즈니스 계산 및 판단
- 도메인 전문가가 이해 가능한 개념

**Presentation 지원 → Helpers**

- UI 표시용 포맷팅 (displayName, formattedDate, emoji 등)
- 색상, 아이콘 등 UI 관련 속성
- View에서 사용하는 computed property

**Data 지원 → Helpers**

- DTO 변환 (toNetworkDTO, fromDTO 등)
- API 요청/응답 매핑
- 데이터베이스 모델 변환

```swift
// Domain/Entities/Diary.swift - 비즈니스 로직
struct Diary {
    // 비즈니스 규칙: 공유 가능 여부
    var canBeShared: Bool { isPublic && !content.isEmpty }
}

// Helpers/Diary+Presentation.swift - UI 지원
extension Diary {
    var previewText: String { String(content.prefix(100)) }
    var formattedDate: String { createdAt.formatted() }
}

// Helpers/Diary+DTO.swift - 데이터 변환
extension Diary {
    func toNetworkDTO() -> DiaryDTO { ... }
    static func from(dto: DiaryDTO) -> Diary { ... }
}
```

### 추가 기준

새로운 헬퍼 추가 시 다음을 확인:

**Presentation 지원:**

- [ ] UI 표시를 위한 코드인가?
- [ ] View/ViewModel에서 사용되는가?
- [ ] 비즈니스 로직이 아닌 표현 로직인가?

**Data 지원:**

- [ ] DTO 변환 또는 매핑인가?
- [ ] Repository 구현체에서 사용되는가?
- [ ] Network/Database와 Domain 간 변환인가?

**공통:**

- [ ] Domain Entity나 Common 모듈에 의존하는가?
- [ ] 비즈니스 로직을 포함하지 않는가?
- [ ] 순수 Foundation 확장이 아닌가? (순수 확장은 Foundation 레이어)

### 파일 명명 규칙

**Domain Entity 확장:**

- Presentation 지원: `타입명+Presentation.swift` (예: `User+Presentation.swift`)
- Data 지원: `타입명+DTO.swift` (예: `Diary+DTO.swift`)

**기타:**

- 프로토콜: `프로토콜명.swift` (예: `Copyable.swift`)
- 범용 확장: `타입명+Extensions.swift` (예: `Publisher+Extensions.swift`)
- 범용 함수: `기능명Helpers.swift` (예: `DateHelpers.swift`)
