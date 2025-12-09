//
//  DefaultRemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 10/25/25.
//

import Foundation

enum AuthDataSourceError: Error, Equatable {
    case unauthorized               // 401
    case forbidden                  // 403
    case notFound                   // 404
    case conflict                   // 409
    case validation([String:String])// 422
    case rateLimited(TimeInterval?) // 429 + Retry-After
    case server                     // 5xx
    case badSchema                  // 응답 JSON 형식/타입 불일치
    case unexpected
    case unknown
}

/// 책임: 네트워크 프로토콜 해석
/// 1. Decoding/Encoding
/// 2. 전송 계층 에러를 data source 에러로 매핑
struct DefaultRemoteAuthDataSource: RemoteAuthDataSource {
    private let client: any HTTPNetworking<AuthEndpoint>
    private let decorder: JSONDecoder

    init(client: any HTTPNetworking<AuthEndpoint>, decorder: JSONDecoder = .init()) {
        self.client = client
        self.decorder = decorder
    }

    func requestOtpCode(payload: NetAuth.OTP.Request, idempotencyKey: String?) async throws -> NetCommon.Void {
        let result = await client.request(.requestOtpCode(payload: payload))

        switch result {
        case .success(let response):
            let decodingResult = Result<NetCommon.Void, AuthDataSourceError>.catching {
                try decorder.decode(NetCommon.Void.self, from: response.body!)
            } mapError: { error in
                return .badSchema
            }

            if case .failure(let failure) = decodingResult {
                throw mapToDataSourceError(failure)
            }

            return try decodingResult.get()
        case .failure(let error):
            throw mapToDataSourceError(error)
        }
    }

    func verify(payload: NetAuth.Email.Request, idempotencyKey: String?) async throws -> NetAuth.Email.Response {
        let result = await client.request(.verify(payload: payload))
            .mapError { self.mapToDataSourceError($0) }

        // TODO: Data Source 개발 및 DataSource Error 정의
        // Endpoint 쪽 Request Model 고민해볼 것
        switch result {
        case .success(let response):
            let decodingResult = Result<NetAuth.Email.Response, AuthDataSourceError>.catching {
                try decorder.decode(NetAuth.Email.Response.self, from: response.body!)
            } mapError: { error in
                return .badSchema
            }

            if case .failure(let failure) = decodingResult {
                throw mapToDataSourceError(failure)
            }

            return try decodingResult.get()
        case .failure(let error):
            throw mapToDataSourceError(error)
        }
    }

    func verify(payload: NetAuth.Apple.Request, idempotencyKey: String?) async throws -> NetAuth.Apple.Response {
        let result = await client.request(.authenticateWithApple(payload: payload))

        switch result {
        case .success(let response):
            let decodingResult = Result<NetAuth.Email.Response, AuthDataSourceError>.catching {
                try decorder.decode(NetAuth.Email.Response.self, from: response.body!)
            } mapError: { error in
                return .badSchema
            }

            if case .failure(let failure) = decodingResult {
                throw failure
            }

            return try decodingResult.get()
        case .failure(let error):
            throw mapToDataSourceError(error)
        }
    }

    private func mapToDataSourceError(_ error: Error) -> AuthDataSourceError {
        guard let transportError = error as? TransportError else {
            // TODO: 디코딩 에러 매핑
            return .unexpected
        }

        // MARK: TransportError 에러 매핑
        fatalError("implement error mapping")
    }
}
