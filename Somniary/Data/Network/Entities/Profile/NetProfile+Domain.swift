//
//  NetProfile+Domain.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

extension NetProfile.Get.Response {
    func toDomain() -> UserProfile {
        return .init(
            id: id,
            userId: userId,
            name: name,
            email: email,
            emailVerified: emailVerified,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
