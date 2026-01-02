//
//  DependencyFailure.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//


import Foundation

/// 외부 의존성 때문에 유스케이스를 수행하지 못한 실패
/// - DB, 네트워크, 외부 API 등
enum DependencyFailure: Equatable {
    enum Dependency: Equatable {
        enum ExternalService {
            case server
            // TODO: 외부 서비스 추가
        }

        case database
        case cache
        case search
        case externalAPI(service: ExternalService)
    }

    enum Operation: Equatable {
        /// Side Effect 정의 - 이 호출 전후로 시스템/외부 세계의 상태가 바뀌는가?

        /// Side Effect 없음
        case read

        /// Side Effect 발생시킴
        case write
        case transaction

        /// 네트워크/서버 장애 등으로 호출 실패를 의미함
        /// - 네트워크 타임 아웃, DNS, TLS
        /// - 서버 5xx 장애
        /// - 429 rate limit
        ///
        /// 인증 상태 변화/정책 거절은 도메인 에러에서 정의
        case refreshToken

        case unknown
    }

    enum Certainty: Equatable {
        /// Side Effect 없고 실패가 명확함
        /// 로컬에서 요청 생성 실패, 네트워크 전송도 못함, 서버가 명확히 거절(4xx 중 일부)
        case definitelyFailed

        /// 처리됐을 수도/안 됐을 수도 있음
        /// 서버에 보낸 뒤 응답을 못 받음, commit timeout, connection drop after send
        case outcomeUnknown

        /// 배치/멀티 작업에서 일부만 성공
        /// 여러 필드/여러 엔티티 업데이트, 멀티 업로드
        case partiallySucceeded
    }

    /// 의존성 호출 실패/가용성 문제
    /// - 네트워크 불가/타임아웃/DNS/TLS
    /// - 서버 장애
    case unavailable(
        dependency: Dependency,
        operation: Operation = .unknown,
        retriable: Bool = false,
        certainty: Certainty,
        attempts: Int? = nil,
        /// HTTP 상태 코드, 응답 못 받으면 nil
        /// DB/캐시처럼 HTTP 아니면 causeCode 에 명시
        lastStatus: Int? = nil,
        /// 앱에서 생성한 ID (UseCase 단위 UUID)
        clientCorrelationId: String? = nil,
        /// 서버 응답으로 받은 Trace/Request ID
        serverCorrelationId: String? = nil,
        causeCode: String? = nil
    )

    /// 429 retryAfterSeconds
    case rateLimited(
        dependency: Dependency,
        retryAfterSeconds: Int? = nil,
        correlationId: String? = nil,
        causeCode: String? = nil
    )

    /// 응답 계약 위반
    case contractViolation(
        dependency: Dependency,
        operation: Operation,
        lastStatus: Int? = nil,
        /// 앱에서 생성한 ID (UseCase 단위 UUID)
        clientCorrelationId: String? = nil,
        /// 서버 응답으로 받은 Trace/Request ID
        serverCorrelationId: String? = nil,
        causeCode: String? = nil
    )

    /// 응답 계약 밖
    case badResponse(String)
}
