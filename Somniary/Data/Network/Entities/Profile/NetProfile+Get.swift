//
//  NetProfile+Get.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

extension NetProfile {

    enum Get {
        struct Response: Codable {
            let id: String
            let userId: String
            let name: String
            let email: String
            let emailVerified: Bool
            let createdAt: Date
            let updatedAt: Date

            enum CodingKeys: String, CodingKey {
                case id, name
                case createdAt = "created_at"
                case updatedAt = "updated_at"
                case userId = "user_id"
                case email
                case emailVerified = "email_verified"
            }
        }

        struct Cached: Codable {
            let dto: Response
            let savedAt: Date
        }
    }
}

extension UserProfile {
    func toDto() -> NetProfile.Get.Response {
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
