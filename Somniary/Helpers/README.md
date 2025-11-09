## Helpers

### 목적

애플리케이션 도메인 로직 구성에 필요한 프로젝트 특화 헬퍼 함수 집합

- 프로젝트 컨텍스트 내에서만 의미 있는 코드
- Domain Entity 의 다른 레이어(UI/Data) 지원용 확장

### 아키텍처 원칙

1. **프로젝트 특화**: 앱의 비즈니스 로직을 지원하는 헬퍼
2. **도메인 의존**: Domain/Presentation 레이어에서 사용되는 확장/유틸리티
3. **Common과 구분**: 독립 재사용이 목적이 아닌, 프로젝트 컨텍스트 내에서 사용
4. **단방향 참조**: Core, Domain, Common은 참조 가능하나 역방향 참조 금지

### 의존성 규칙

- Helpers → Core (아키텍처 인터페이스)
- Helpers → Domain (비즈니스 엔티티)
- Helpers → Common (독립 유틸리티)

### Common vs Helpers 구분

| 구분        | Common                   | Helpers                   |
| ----------- | ------------------------ | ------------------------- |
| 목적        | 독립 재사용 가능한 모듈  | 프로젝트 도메인 로직 지원 |
| 의존성      | 최소 (Foundation만)      | Domain/Common 참조 가능   |
| 재사용 범위 | 다른 프로젝트에서도 사용 | 이 프로젝트 내에서만 의미 |

### Extension for Domain Entity 가이드

Domain Entity 에 기능을 추가할 때 다음 기준으로 위치를 결정:

**비즈니스 로직 → Domain 내부**

- 도메인 규칙과 검증
- 비즈니스 계산 및 판단
- 도메인 전문가가 이해 가능한 개념

**기술 지원 → Helpers에 extension**

- 프레젠테이션 포맷팅 (displayName, formattedDate 등)
- DTO 변환 (toNetworkDTO, toViewDTO 등)
- UI 관련 computed property
- 외부 레이어를 위한 유틸리티

```swift
// Domain/Entities/Diary.swift - 비즈니스 로직
struct Diary {
    var canBeShared: Bool { isPublic && !content.isEmpty }  // 도메인 규칙
}

// Helpers/Diary+Extensions.swift - 기술 지원
extension Diary {
    var previewText: String { String(content.prefix(100)) }  // UI 지원
    func toNetworkDTO() -> DiaryDTO { ... }  // 변환
}
```

### 추가 기준

새로운 헬퍼 추가 시 다음을 확인:

- [ ] 프로젝트의 도메인 로직에 특화되어 있는가?
- [ ] 비즈니스 로직이 아닌 기술적 지원인가?
- [ ] Domain Entity 확장인 경우, 프레젠테이션/변환 목적인가?

### 파일 명명 규칙

- Extension: 타입명+Extensions.swift (예: Result+Extensions.swift, User+Extensions.swift)
- Protocol: 프로토콜명.swift (예: Copyable.swift)
- 범용 함수: 기능명Helpers.swift (예: DateHelpers.swift)
