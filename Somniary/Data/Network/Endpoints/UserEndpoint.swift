//
//  UserEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

enum UserEndpoint: SomniaryEndpoint {
    case getAuth
    case getProfile(id: String)
    case update(id: String, name: String)
}

extension UserEndpoint {
    var path: String {
        return "/rest/v1/profiles"
    }

    var method: HTTPMethod {
        switch self {
        case .getAuth:
            return .get
        case .getProfile:
            return .get
        case .update:
            return .patch
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .update(id: id):
            return [URLQueryItem(name: "user_id", value: "eq.\(id))")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case .update(_, let name):
            return .jsonObject(
                data: ["name": name]
            )
        default:
            return .plain
        }
    }
}
