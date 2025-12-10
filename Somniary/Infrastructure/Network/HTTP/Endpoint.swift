//
//  Endpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: any Any & Sendable]

enum RequestDataType {
    /// Request body 없음
    case plain
    /// Dictionary
    case jsonObject(data: Parameters)
    /// Encodable  Object
    case entity(data: Encodable)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
}


/// 어디로, 어떻게, 무엇을 보낼지 정의
protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var payload: RequestDataType? { get }

    func asURLRequest() throws -> URLRequest
}

extension Endpoint {
    var headers: HTTPHeaders? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var payload: RequestDataType? { .plain }
}
