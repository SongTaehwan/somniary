## Foundation

### 목적

모든 레이어에서 사용 가능한 순수 Foundation 타입 확장 및 프로젝트 독립적 유틸리티

- Foundation 프레임워크 타입의 확장
- 프로젝트에 종속되지 않은 범용 함수
- 다른 프로젝트에서도 그대로 사용 가능한 순수 코드

### 아키텍처 원칙

1. **순수성**: Foundation 타입의 확장만 포함, 비즈니스 로직 없음
2. **프로젝트 독립**: 특정 프로젝트 컨텍스트에 의존하지 않음
3. **재사용성**: 다른 프로젝트에 복사해서 바로 사용 가능
4. **최소 의존성**: Apple Foundation 외 의존성 없음

### 의존성 규칙

```
Foundation → Apple Foundation
```

**금지 사항:**

- Foundation → Domain (Domain 타입 참조 금지)
- Foundation → Common (프로젝트 모듈 참조 금지)
- Foundation → Helpers (프로젝트 헬퍼 참조 금지)
- Foundation → 외부 라이브러리

### 포함 대상

**Foundation 타입 확장:**

- `Result`, `Array`, `String`, `Date` 등의 확장
- 순수 함수 (side effect 없음)
- 범용 유틸리티 함수

**예시:**

```swift
// ✅ 포함
extension Result {
    static func catching(_ body: () throws -> Success, mapError: (Error) -> Failure) -> Self
}

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
    var isValidEmail: Bool { ... }
}
```

### 제외 대상

**프로젝트 특화 코드:**

- Domain Entity 확장 (→ Helpers)
- 비즈니스 로직 (→ Domain/Utils)
- 프로젝트 특화 유틸리티 (→ Helpers)
- 독립 기능 모듈 (→ Common)

**예시:**

```swift
// 제외 - Domain 타입 의존
extension Result where Failure == DomainError {
    // → Domain/Utils로 이동
}

// 제외 - Entity 확장
extension User {
    var displayName: String { ... }
    // → Helpers로 이동
}

// 제외 - 비즈니스 로직
func validateBusinessRule() -> Bool {
    // → Domain/Utils로 이동
}
```

### 레이어별 사용 가이드

```
┌─────────────────────────────────────────┐
│ Presentation Layer                      │
│  → Foundation                           │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Domain Layer                             │
│  → Foundation                           │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Data/Infrastructure Layer               │
│  → Foundation                           │
└─────────────────────────────────────────┘
```

모든 레이어에서 자유롭게 사용 가능

### 추가 기준

새로운 확장/유틸리티 추가 시 다음을 확인:

- [ ] Foundation 타입의 확장인가?
- [ ] 프로젝트 독립적인가? (다른 프로젝트에서도 사용 가능)
- [ ] 비즈니스 로직을 포함하지 않는가?
- [ ] Domain, Common, Helpers 타입에 의존하지 않는가?
- [ ] 순수 함수인가? (side effect 없음)
- [ ] 외부 라이브러리에 의존하지 않는가?

### 파일 명명 규칙

- Extension: `타입명+Extensions.swift` (예: `Result+Extensions.swift`)
- 범용 함수: `기능명.swift` (예: `DateFormatters.swift`)

### 향후 계획

- Swift Package로 분리하여 독립 라이브러리화
- 다른 프로젝트에서 재사용
