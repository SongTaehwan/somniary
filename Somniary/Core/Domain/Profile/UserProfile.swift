//
//  Profile.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct UserProfile: Equatable, Sendable {
    let id: String
    let userId: String
    var name: String
    var email: String
    let emailVerified: Bool
    let createdAt: Date
    let updatedAt: Date

    var thumbnail: String {
        return "circle.person.fill"
    }
}
