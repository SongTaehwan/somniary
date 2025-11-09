## Foundation

### 목적

모든 레이어에서 사용 가능한 Apple 표준 프레임워크 타입 확장 및 프로젝트 독립적 유틸리티

- Apple 표준 프레임워크 타입의 확장 및 범용 함수로 구성
- 프로젝트에 종속되지 않은 범용 함수
- 다른 프로젝트에서도 그대로 사용 가능한 순수 코드

### 레이어 구조

```
Foundation/
├── Core/              # Foundation 타입 확장 (필수)
│   ├── Extensions/
│   └── Protocols/
└── Combine/           # Combine 타입 확장 (선택)
    └── Publisher+Extensions.swift
```

### 아키텍처 원칙

1. **순수성**: Apple 표준 프레임워크 타입의 확장만 포함, 비즈니스 로직 없음
2. **프로젝트 독립**: 특정 프로젝트 컨텍스트에 의존하지 않음
3. **재사용성**: 다른 프로젝트에 복사해서 바로 사용 가능
4. **최소 의존성**: Apple 표준 프레임워크만 의존

### 의존성 규칙

```
Foundation/Core    → Apple Foundation, Swift Standard Library
Foundation/Combine → Combine
```

**금지 사항:**

- Foundation → Domain (Domain 타입 참조 금지)
- Foundation → Common (프로젝트 모듈 참조 금지)
- Foundation → Helpers (프로젝트 헬퍼 참조 금지)
- Foundation → UIKit, SwiftUI (UI 프레임워크)
- Foundation → 외부 라이브러리

### 포함 대상

#### Core (Foundation 타입 확장)

**Foundation 타입:**

- `Result`, `Array`, `String`, `Date`, `Optional` 등의 확장
- Swift Standard Library 타입 확장
- 순수 함수 (side effect 없음)

**예시:**

```swift
// Foundation/Core/Extensions/Result+Extensions.swift
extension Result {
    static func catching(_ body: () throws -> Success, mapError: (Error) -> Failure) -> Self
}

// Foundation/Core/Extensions/Array+Extensions.swift
extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

// Foundation/Core/Extensions/String+Extensions.swift
extension String {
    var isValidEmail: Bool { ... }
}
```

#### Combine (Combine 타입 확장)

**Combine 타입:**

- `Publisher`, `AnyPublisher` 등의 확장
- Combine 관련 유틸리티

**예시:**

```swift
// Foundation/Combine/Publisher+Extensions.swift
import Combine

extension Publisher {
    func partition(by: ...) -> (included: AnyPublisher, excluded: AnyPublisher)
    func withLatest<Ref: Publisher>(from: Ref) -> AnyPublisher
}
```

### 제외 대상

**프로젝트 특화 코드:**

- Domain Entity 확장 (→ Helpers)
- 비즈니스 로직 (→ Domain/Utils)
- 프로젝트 특화 유틸리티 (→ Helpers)
- 독립 기능 모듈 (→ Common)

**UI 프레임워크:**

- UIKit 타입 확장 (→ Helpers 또는 별도 레이어)
- SwiftUI 타입 확장 (→ Helpers 또는 별도 레이어)

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

// 제외 - UI 프레임워크
extension View {  // SwiftUI
    // → Helpers 또는 별도 레이어
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

**Core 추가 시:**

- [ ] Foundation 또는 Swift Standard Library 타입의 확장인가?
- [ ] 프로젝트 독립적인가? (다른 프로젝트에서도 사용 가능)
- [ ] 비즈니스 로직을 포함하지 않는가?
- [ ] Domain, Common, Helpers 타입에 의존하지 않는가?
- [ ] 순수 함수인가? (side effect 없음)

**Combine 추가 시:**

- [ ] Combine 타입의 확장인가?
- [ ] 프로젝트 독립적인가?
- [ ] 비즈니스 로직을 포함하지 않는가?
- [ ] Presentation 레이어 특화 로직이 아닌가? (특화 로직은 Helpers)

### 파일 명명 규칙

**Core:**

- Extension: `타입명+Extensions.swift` (예: `Result+Extensions.swift`)
- Protocol: `프로토콜명.swift` (예: `Copyable.swift`)
- 범용 함수: `기능명.swift` (예: `DateFormatters.swift`)

**Combine:**

- Extension: `타입명+Extensions.swift` (예: `Publisher+Extensions.swift`)

### SPM 구조 (향후 계획)

Foundation 레이어는 Swift Package로 분리하여 프레임워크별로 선택적 설치 가능하도록 구성할 예정입니다.

**Package Products:**

```swift
// Package.swift
products: [
    .library(name: "SomniaryFoundationCore", targets: ["Core"]),       // 필수
    .library(name: "SomniaryFoundationCombine", targets: ["Combine"]), // 선택
    .library(name: "SomniaryFoundation", targets: ["Core", "Combine"]), // 전체
]
```

**사용 예시:**

```swift
// Core만 필요한 경우
dependencies: [
    .product(name: "SomniaryFoundationCore", package: "SomniaryFoundation")
]

// Core + Combine 필요한 경우
dependencies: [
    .product(name: "SomniaryFoundationCore", package: "SomniaryFoundation"),
    .product(name: "SomniaryFoundationCombine", package: "SomniaryFoundation")
]

// 전체 사용 (편의)
dependencies: [
    .product(name: "SomniaryFoundation", package: "SomniaryFoundation")
]
```

**장점:**

- 프레임워크별 선택적 설치 (번들 크기 최소화)
- 명확한 의존성 분리
- 독립적인 버전 관리
- 다른 프로젝트에서 재사용 가능
