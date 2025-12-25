//
//  RemoteDataSourceError.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

/// HTTP 에러에 대한 해석
enum RemoteDataSourceError: Error, Equatable {
    /// 토큰 만료
    case tokenExpired
    /// 유효하지 않은 토큰
    case invalidToken
    // 인증 필요
    case unauthorized
    /// 권한 없음
    case forbidden
    /// 리소스를 찾을 수 없음 (404)
    case resourceNotFound
    /// 리소스가 1개 이상이거나 없음
    case resouceNotSingular
    /// 데이터 충돌 (409)
    case conflict
    /// 잘못된 요청 (400, 422 등 기타 4xx)
    case invalidRequest
    /// 서버 에러 (5xx)
    case serverError
    /// PostgREST error
    case dbError
    /// HTTP 메서드가 허용되지 않음 (405)
    case methodNotAllowed
    /// 요청한 미디어 타입을 지원하지 않음 (415)
    case unsupportedMediaType
    /// 요청한 범위를 만족할 수 없음 (416)
    case rangeNotSatisfiable

    // 요청 데이터 관련 에러
    case requestBuildFailed
    /// 인코딩 실패
    case encodingFailed

    // 응답 데이터 관련 에러
    case emptyResponse
    /// 디코딩 실패
    case decodingFailed

    // 네트워크 관련 에러
    case networkUnavailable
    /// 타임아웃
    case timeout
    /// 요청 취소
    case cancelled

    case securityError

    /// 예상 못한 케이스
    case unknown

    /// 발생하지 않을 케이스
    case unexpected
}
