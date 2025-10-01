//
//  AuthEndpoint.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Alamofire

enum AuthEndpoint: SomniaryEndpoint {

    enum VerificationType: String, Encodable {
        case magiclink
        case signup
    }

    case login(email: String)
    case signup(email: String)
    case verify(email: String, otpCode: String, type: VerificationType)
    case refreshToken(refreshToken: String)
    case logout
}

extension AuthEndpoint {
    var path: String {
        switch self {
        case .login, .signup:
            return "/auth/v1/magiclink"
        case .verify:
            return "/auth/v1/verify"
        case .refreshToken:
            return "/auth/v1/token"
        case .logout:
            return "/auth/v1/logout"
        }
    }

    var method: HTTPMethod { .post }

    var payload: RequestDataType? {
        switch self {
        case .verify(email: let email, otpCode: let otpCode, type: let verificationType):
            return .jsonObject(
                data: [
                    "email": email,
                    "token": otpCode,
                    "type": verificationType.rawValue
                ],
                encoder: JSONEncoding.default
            )
        case .login(email: let email):
            return .jsonObject(
                data: ["email": email],
                encoder: JSONEncoding.default
            )
        case .signup(email: let email):
            return .jsonObject(
                data: ["email": email],
                encoder: JSONEncoding.default
            )
        case .refreshToken(refreshToken: let token):
            return .jsonObject(
                data: ["refresh_token": token],
                encoder: JSONEncoding.default
            )
        default:
            return nil
        }
    }
}
