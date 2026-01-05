//
//  RemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

// TODO: 현재 인증과 회원가입을 모두 하고 있기 떄문에 AuthDomainError 에도 2가지 역할을 기대하고 있다.
// 별도의 두 역할 각각에 해당하는 Domain 에러를 정의하고 에러 타입으로 채택해서 UseCase 에서 매핑한다.

/// 역할: Data 레이어 계층 모델을 Domain 모델로 변환
/// '데이터 접근을 조율'하고, 복잡한 변환은 위임하고 간단한 작업은 직접 처리하여 Domain Entity 제공
///
/// 1. DTO 를 Domain 객체로 매핑
/// 2. Data source error 를 Domain error 로 매핑
struct DefaultRemoteAuthRepository: RemoteAuthRepository {
    private let dataSource: RemoteAuthDataSource

    init(dataSource: RemoteAuthDataSource) {
        self.dataSource = dataSource
    }

    /// OTP 코드 이메일 전송
    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async -> Result<Void, PortFailure<IdentityBoundaryError>> {
        let result = await self.dataSource.requestOtpCode(payload: .init(email: email, createUser: createUser), idempotencyKey: nil)
            .mapError(mapToDomainError(_:))

        return result
    }

    /// 인증 토큰 발급
    func verify(email: String, otpCode: String, idempotencyKey: String?) async -> Result<TokenEntity, PortFailure<IdentityBoundaryError>> {
        let result = await self.dataSource.verify(payload: .init(email: email, token: otpCode), idempotencyKey: nil)
            .mapError(mapToDomainError(_:))
            .map { dto in
                TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }

        return result
    }

    /// 인증 토큰 발급
    func verify(credential: AppleCredential, idempotencyKey: String?) async -> Result<TokenEntity, PortFailure<IdentityBoundaryError>> {
        let result = await self.dataSource.verify(payload: .init(idToken: credential.identityToken, nonce: credential.nonce), idempotencyKey: nil)
            .mapError(mapToDomainError(_:))
            .map { dto in
                TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
            }

        return result
    }

    func logout() async -> Result<Void, PortFailure<IdentityBoundaryError>> {
        let result = await self.dataSource.logout()
            .mapError(mapToDomainError(_:))

        return result
    }

    private func mapToDomainError(_ error: Error) -> PortFailure<IdentityBoundaryError> {
        guard let datasourceError = error as? DataSourceError else {
            return .system(.internalInvariantViolation(reason: "Unhandled error: \(error)"))
        }

        switch datasourceError {
        case .transport(let transportError):
            switch transportError {
            case .cancelled:
                return .system(.dependencyUnavailable(details: "cancelled"))
            case .network(_), .tls, .unknown:
                return .system(.dependencyUnavailable(details: "network error"))
            case .requestBuildFailed:
                return .system(.contractViolation(details: "Failed to build URL request"))
            }
        case .unauthorized(let unauthorizedReason):
            switch unauthorizedReason {
            case .tokenExpired:
                return .boundary(.auth(.authRequired(reason: .accessTokenExpired)))
            case .invalidToken:
                return .boundary(.auth(.authRequired(reason: .accessTokenInvalid)))
            case .unauthorized:
                return .boundary(.auth(.authRequired(reason: .unknownUnauthorized)))
            }
        case .forbidden(let forbiddenReason):
            switch forbiddenReason {
            case .roleDenied:
                return .boundary(.auth(.permissionDenied(reason: .roleDenied)))
            case .insufficientScope:
                return .boundary(.auth(.permissionDenied(reason: .insufficientScope)))
            case .resourceForbidden:
                return .boundary(.auth(.permissionDenied(reason: .resourceForbidden)))
            case .forbidden:
                return .boundary(.auth(.permissionDenied(reason: .unknownForbidden)))
            }
        case .resource(let resourceReason):
            switch resourceReason {
            case .notSingular:
                return .system(.contractViolation(details: "Not Singlular"))
            case .conflict:
                return .boundary(.registration(.alreadyExists(reason: .duplicatedEmail)))
            case .notFound:
                // 응답을 기대하는데 없는 경우에 해당
                return .system(.contractViolation(details: "Not Found"))
            }
        case .client(let clientReason):
            // 요청에 대한 계약 위반으로 간주
            return .system(.contractViolation(details: "HTTP 4xx: \(clientReason)"))
        case .server(let serverReason):
            // 의존성 실패로 간주
            return .system(.dependencyUnavailable(details: "internal server error: \(serverReason)"))
        case .response(let responseReason):
            // 응답에 대한 계약 위반으로 간주
            switch responseReason {
            case .emptyResponse:
                return .system(.contractViolation(details: "Empty Response"))
            case .invalidPayload:
                return .system(.contractViolation(details: "Invalid Payload"))
            case .decodingFailed:
                return .system(.contractViolation(details: "decodingFailed"))
            }
        case .invariantViolation(let reason):
            return .system(.internalInvariantViolation(reason: reason))
        }
    }
}
