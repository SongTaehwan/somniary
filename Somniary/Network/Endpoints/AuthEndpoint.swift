//
//  AuthEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

enum AuthEndpoint: SomniaryEndpoint {

    case requestOtpCode(email: String, createUser: Bool)
    case verify(email: String, otpCode: String)
    case refreshToken(refreshToken: String)
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
        }
    }

    var method: HTTPMethod { .post }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .logout:
            return [URLQueryItem(name: "scope", value: "local")]
        default:
            return nil
        }
    }

    var payload: RequestDataType? {
        switch self {
        case .verify(email: let email, otpCode: let otpCode):
            return .jsonObject(
                data: [
                    "email": email,
                    "token": otpCode,
                    "type": "email"
                ],
                encoder: JSONEncoding.default
            )
        case .requestOtpCode(email: let email, let createUser):
            return .jsonObject(
                data: [
                    "email": email,
                    "create_user": createUser
                ],
                encoder: JSONEncoding.default
            )
        case .refreshToken(refreshToken: let token):
            return .jsonObject(
                data: ["refresh_token": token],
                encoder: JSONEncoding.default
            )

        case .logout:
            return .plain
        }
    }
}
