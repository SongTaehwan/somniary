//
//  UserEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

enum UserEndpoint: SomniaryEndpoint {
    case getProfile
    case getProfileById(id: String)
    case update(id: String, payload: NetProfile.Update.Request)
}

extension UserEndpoint {
    var path: String {
        return "/rest/v1/profiles"
    }

    var method: HTTPMethod {
        switch self {
        case .getProfile, .getProfileById:
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
        case let .getProfileById(id):
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
