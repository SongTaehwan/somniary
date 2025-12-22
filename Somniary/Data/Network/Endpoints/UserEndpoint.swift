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
    case update(id: String, payload: NetProfile.Update.Request)
}

extension UserEndpoint {
    var path: String {
        switch self {
        case .getAuth:
            return "/auth/v1/user"
        case .getProfile, .update:
            return "/rest/v1/profiles"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAuth, .getProfile:
            return .get
        case .update:
            return .patch
        }
    }

    var headers: HTTPHeaders? {
        return [
            "apiKey": AppInfo.shared.domainClientKey,
            "Content-Type": "application/json",
            "Authorization": "Bearer \(TokenRepository.shared.getAccessToken() ?? "")"
        ]
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .update(id, _):
            return [URLQueryItem(name: "user_id", value: "eq.\(id))")]
        case let .getProfile(id):
            return [URLQueryItem(name: "user_id", value: "eq.\(id))")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case let .update(_, payload):
            return .entity(data: payload)
        default:
            return .plain
        }
    }
}
