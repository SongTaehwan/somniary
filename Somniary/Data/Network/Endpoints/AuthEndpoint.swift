//
//  AuthEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

enum AuthEndpoint: SomniaryEndpoint {
    case authenticateWithApple(payload: NetAuth.Apple.Request)
    case requestOtpCode(payload: NetAuth.OTP.Request)
    case verify(payload: NetAuth.Email.Request)
    case refreshToken(payload: NetAuth.RefreshToken.Request)
    case logout
}

extension AuthEndpoint {
    var path: String {
        switch self {
        case .requestOtpCode:
            return "/auth/v1/otp"
        case .verify:
            return "/auth/v1/verify"
        case .refreshToken:
            return "/auth/v1/token"
        case .logout:
            return "/auth/v1/logout"
        case .authenticateWithApple:
            return "/auth/v1/token"
        }
    }

    var method: HTTPMethod { .post }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .logout:
            return [URLQueryItem(name: "scope", value: "local")]
        case .authenticateWithApple:
            return [URLQueryItem(name: "grant_type", value: "id_token")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case .verify(let payload):
            return .entity(data: payload)
        case .requestOtpCode(let payload):
            return .entity(data: payload)
        case .refreshToken(let payload):
            return .entity(data: payload)
        case .authenticateWithApple(let payload):
            return .entity(data: payload)
        case .logout:
            return .plain
        }
    }
}
