//
//  PreconditionError.swift
//  Somniary
//
//  Created by 송태환 on 12/24/25.
//

import Foundation

/// 도메인 공통 에러
/// 인증 등
enum PreconditionError: Error, Equatable {
    case loginRequired
}
