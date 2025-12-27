//
//  DateSourceError.swift
//  Somniary
//
//  Created by 송태환 on 12/27/25.
//

import Foundation

/// HTTP 에러에 대한 해석
enum DataSourceError: Error, Equatable {
    // Transport (전송 단계에서 실패)
    case transport(TransportError)

    // Auth (보통 401/403)
    case unauthorized(UnauthorizedReason)   // 401
    case forbidden(ForbiddenReason?)        // 403

    // Resource / State (주로 404/409 + “싱귤러 기대 위반” 같은 데이터 상태)
    case resource(ResourceReason)

    // Client request is invalid (주로 4xx 중 요청 문제)
    case client(ClientReason)

    // Server / Backend (주로 5xx + 백엔드 특화)
    case server(ServerReason)

    // Response handling (바디/디코딩/스키마)
    case response(ResponseReason)

    // Fallbacks
    case unknown
    case invariantViolation(reason: String)    // (기존 unexpected 같은 “여기 오면 버그”)
}

// MARK: - Unauthorized (401)
enum UnauthorizedReason: Error, Equatable {
    /// 서버가 “토큰 만료”를 명확히 알려준 경우
    case tokenExpired

    /// 서버가 “토큰 무효(서명/포맷/리보크 포함 가능)”를 명확히 알려준 경우
    case invalidToken

    /// 401이긴 한데 세부 코드를 파싱하지 못했거나 제공되지 않은 경우
    case unauthorized
}

// MARK: - Forbidden (403)
enum ForbiddenReason: Error, Equatable {
    /// 권한 범위 부족
    case insufficientScope

    /// 권한 없음
    case roleDenied

    /// 접근 차단된 리소스
    case resourceForbidden

    /// 403 이긴 한데 세부 코드를 파싱하지 못했거나 제공되지 않은 경우
    case forbidden
}

// MARK: - Resource / State
enum ResourceReason: Error, Equatable {
    /// “단일 리소스 기대” 위반 (0개 or 2개+)
    case notSingular

    /// 409
    case conflict

    /// 404 이긴 한데 세부 코드를 파싱하지 못했거나 제공되지 않은 경우
    case notFound
}

// MARK: - Client (4xx request-side)
enum ClientReason: Error, Equatable {
    /// 400/422 등
    case invalidRequest

    /// 405
    case methodNotAllowed

    /// 415
    case unsupportedMediaType

    /// 416
    case rangeNotSatisfiable
}

// MARK: - Server (5xx / backend-specific)
enum ServerReason: Error, Equatable {
    /// PostgREST 등 백엔드 특화 에러
    case dbError

    /// 502
    case badGateway

    /// 503
    case serviceUnavailable

    /// 504
    case gatewayTimeout

    /// 5xx 이긴 한데 세부 코드를 파싱하지 못했거나 제공되지 않은 경우
    case serverError
}

// MARK: - Response
enum ResponseReason: Error, Equatable {
    /// 리턴 값을 기대했으나 없는 경우
    case emptyResponse

    /// 응답 데이터 디코딩 실패
    case decodingFailed

    /// 스키마 검증 실패, 필수 필드 누락 등
    case invalidPayload
}
