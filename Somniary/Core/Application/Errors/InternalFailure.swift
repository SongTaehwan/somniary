//
//  InternalFailure.swift
//  Somniary
//
//  Created by 송태환 on 12/24/25.
//

import Foundation

/// 앱 내부 실행, 환경 문제로 인한 유스케이스의 실패
/// - 권한, 인코딩, 디코딩, 타임아웃, 취소, 로직 오류 등
enum InternalFailure: Error, Equatable {
    enum CancelledOperation: Equatable {
        case network
        case task
        case user
    }

    /// 사용자가 화면 닫음, Task 취소, 네트워크 취소 등
    case cancelled(CancelledOperation)

    // MARK: 런타임 실패
    case timeout

    /// DTO 인코딩/디코딩 실패
    case encodingFailed
    case decodingFailed

    /// 사진 권한/푸시 권한 등 OS 레벨 권한 부족
    case permissionDenied(String)

    /// 로직 상의 내부 오류
    /// 도메인 불변식 위반은 UserCaseError.unexpected 로 처리할 것
    case internalError(String)
}
