//
//  AuthenticationError.swift
//  Somniary
//
//  Created by 송태환 on 12/10/25.
//

import Foundation

enum AuthenticationError: Error, Equatable {
    case resourceAlreadyExists
    
    case resourceNotFound

    /// 취소
    case operationCancelled

    /// 인증 필요
    case authenticationRequired

    /// 권한 없음
    case permissionDenied

    /// 네트워크 연결 불가
    case networkUnavailable

    /// 서버 오류
    case serverError

    /// 클라이언트 버그 (앱 코드 문제)
    case systemError(reason: String)

    case serviceUnavailable

    case unexpected

    case unknown
}
