//
//  RemoteDataSourceError.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

enum RemoteDataSourceError: Error, Equatable {
    // http 상태 코드 관련 에러
    /// 인증 실패 (401)
    case unauthorized
    /// 권한 없음 (403)
    case forbidden
    /// 리소스를 찾을 수 없음 (404)
    case notFound
    /// 데이터 충돌 (409)
    case conflict
    /// 잘못된 요청 (400, 422 등 기타 4xx)
    case invalidRequest
    /// 서버 에러 (5xx)
    case serverError

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

    /// 발생하면 안돼는 예외 케이스
    case unknown
}
