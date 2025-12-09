//
//  DiaryEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

enum DiaryEndpoint: SomniaryEndpoint {
    case create(payload: NetDiary.Create.Request)
    case getList
    case get(id: String)
    case update(id: String, payload: NetDiary.Update.Request)
    case delete(id: String)
}

extension DiaryEndpoint {

    var path: String {
        return "/rest/v1/diaries"
    }

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .getList:
            return .get
        case .get:
            return .get
        case .update:
            return .patch
        case .delete:
            return .delete
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .get(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        case let .update(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        case let .delete(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case .create(let payload):
            return .entity(data: payload)
        case .update(_, let payload):
            return .entity(data: payload)
        default:
            return .plain
        }
    }
}
