//
//  ProfileDomainError+UserMessageKey.swift
//  Somniary
//
//  Created by 송태환 on 1/7/26.
//

import Foundation

extension ProfileDomainError: UserMessageKeyProviding {
    var userMessageKey: String {
        switch self {
        case .invalidNickname:
            return "profile.error.invalidNickname"
        }
    }
}
