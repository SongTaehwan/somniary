//
//  ProfileFailureCause.swift
//  Somniary
//
//  Created by 송태환 on 12/25/25.
//

import Foundation

/// Profile 도메인 실패 케이스로 발생할 수 있는 에러 총집합
enum ProfileFailureCause: Error, Equatable {
    case profile(ProfileDomainError)
    case auth(AuthDomainError)
}
