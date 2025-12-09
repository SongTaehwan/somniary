//
//  UserEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

enum UserEndpoint: SomniaryEndpoint {
    case getAuthUser
    case getProfile(id: String)
    case updateProfile(id: String, name: String)
}

extension UserEndpoint {
    var path: String {
        return "/rest/v1/profiles"
    }

    var method: HTTPMethod {
        switch self {
        case .getAuthUser:
            return .get
        case .getProfile:
            return .get
        case .updateProfile:
            return .patch
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .updateProfile(id: id):
            return [URLQueryItem(name: "user_id", value: "eq.\(id))")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case let .updateProfile(_, name: name):
            return .jsonObject(
                data: ["name": name]
            )
        default:
            return .plain
        }
    }
}
