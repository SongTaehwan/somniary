//
//  Endpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

enum RequestDataType {
    /// Request body 없음
    case plain
    case jsonObject(data: Parameters, encoder: ParameterEncoding)
    case entity(data: Encodable, encoder: ParameterEncoder)
}

protocol Endpoint: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var payload: RequestDataType? { get }
}

extension Endpoint {
    var headers: HTTPHeaders? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var payload: RequestDataType? { .plain }

    func asURLRequest() throws -> URLRequest {
        let url = self.baseURL.appending(path: self.path, queryItems: self.queryItems ?? [])
        var request = try URLRequest(url: url, method: self.method, headers: self.headers)
        request.headers.update(.contentType("application/json"))

        if case let .jsonObject(data, encoder) = payload {
            let requestWithPayload = try encoder.encode(request, with: data)
            return requestWithPayload
        }

        if case let .entity(data, encoder) = payload {
            let requestWithEntity = try encoder.encode(data, into: request)
            return requestWithEntity
        }

        return request
    }
}

/// type erasure for Encodable body
struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    init(_ wrapped: Encodable) { _encode = wrapped.encode }
    func encode(to encoder: Encoder) throws { try _encode(encoder) }
}
