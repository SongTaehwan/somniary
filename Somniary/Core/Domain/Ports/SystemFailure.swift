//
//  SystemFailure.swift
//  Somniary
//
//  Created by 송태환 on 1/2/26.
//


enum SystemFailure: Error, Equatable {
    /// 의존성 실패로 결과 값을 사용할 수 없거나 신뢰할 수 없는 경우
    /// 예) offline/timeout/dns/tls/5xx, connection lost.
    case dependencyUnavailable(details: String? = nil)

    /// 429 에러
    /// - retryAfterSeconds: 헤더의 Retry-After 필드 값
    case rateLimited(retryAfterSeconds: Int? = nil)

    /// 의존성 요청/응답 계약을 위반한 경우
    /// 예) unexpected status, not singular, invalid payload, decoding failed.
    case contractViolation(details: String? = nil)

    /// 앱 내 버그 또는 발생해서는 안돼는 경우
    case internalInvariantViolation(reason: String)

    /// 원인 불명
    case unknown(details: String? = nil)
}
