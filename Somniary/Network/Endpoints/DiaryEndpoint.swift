//
//  DiaryEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

enum DiaryEndpoint: SomniaryEndpoint {

    case createDiary(title: String, content: String)
    case getDiaryList
    case getDiary(id: String)
    case updateDiary(id: String, title: String, content: String)
    case deleteDiary(id: String)
}

extension DiaryEndpoint {

    var path: String {
        return "/rest/v1/diaries"
    }

    var method: HTTPMethod {
        switch self {
        case .createDiary:
            return .post
        case .getDiaryList:
            return .get
        case .getDiary:
            return .get
        case .updateDiary:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .getDiary(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        case let .updateDiary(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        case let .deleteDiary(id: id):
            return [URLQueryItem(name: "id", value: "eq.\(id)")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case let .createDiary(title, content):
            return .jsonObject(
                data: [
                    "title": title,
                    "content": content
                ],
                encoder: JSONEncoding.default
            )
        case let .updateDiary(_, title, content):
            return .jsonObject(
                data: [
                    "title": title,
                    "content": content
                ],
                encoder: JSONEncoding.default
            )
        default:
            return .plain
        }
    }
}
