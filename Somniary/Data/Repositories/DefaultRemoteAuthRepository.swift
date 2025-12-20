//
//  RemoteAuthDataSource.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

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

    func requestOtpCode(email: String, createUser: Bool, idempotencyKey: String?) async throws -> VoidResponse {
        do {
            try await self.dataSource.requestOtpCode(payload: .init(email: email, createUser: createUser), idempotencyKey: nil)
            return VoidResponse()
        } catch let error as RemoteDataSourceError {
            throw mapToDomainAuthError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthError.unexpected(snapshot: .init(from: error))
        }
    }

    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity {
        do {
            let dto = try await self.dataSource.verify(payload: .init(email: email, token: otpCode), idempotencyKey: nil)
            return TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
        } catch let error as RemoteDataSourceError {
            throw mapToDomainAuthError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthError.unexpected(snapshot: .init(from: error))
        }
    }

    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity {
        do {
            let dto = try await self.dataSource.verify(payload: .init(idToken: credential.identityToken, nonce: credential.nonce), idempotencyKey: nil)
            return TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
        } catch let error as RemoteDataSourceError {
            throw mapToDomainAuthError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthError.unexpected(snapshot: .init(from: error))
        }
    }

    private func  mapToDomainAuthError(_ error: Error) -> AuthError {
        guard let datasourceError = error as? RemoteDataSourceError else {
            return AuthError(category: .unexpected)
        }

        switch datasourceError {
        case .unauthorized, .forbidden:
            // 인증 필요
            return AuthError(category: .authenticationRequired)
        case .conflict:
            return AuthError(category: .resourceAlreadyExists)
        case .networkUnavailable, .timeout:
            // 네트워크
            return AuthError(category: .networkUnavailable)
        case .serverError:
            // 서버
            return AuthError(category: .serverError)
        case .emptyResponse:
            // 응답 body가 없음 - 서버 응답 구조 문제
            DebugAssert.fail(category: .network, "Server returned empty response")
            return AuthError(
                category: .serverError,
                message: "Server returned empty response"
            )
        case .invalidRequest:
            // 클라이언트 버그로 생긴 오류
            return AuthError(category: .systemError(reason: "네트워크 요청 오류"))
        case .securityError:
            // TLS/인증서 문제 - 클라이언트 또는 서버 설정 문제
            DebugAssert.fail(
                category: .network,
                "Security error - check SSL/TLS configuration"
            )
            return AuthError(
                category: .systemError(reason: "보안 오류"),
                message: "Security error - check SSL/TLS configuration"
            )
        case .decodingFailed:
            DebugAssert.fail(category: .network, "Decoding failed")

            return AuthError(
                category: .systemError(reason: "디코딩 실패"),
                message: "Decoding failed"
            )
        case .encodingFailed:
            DebugAssert.fail(
                category: .network,
                "Encoding failed - check request model definition"
            )

            return AuthError(
                category: .systemError(reason: "인코딩 실패"),
                message: "Encoding failed - check request model definition"
            )
        case .requestBuildFailed:
            DebugAssert.fail(
                category: .network,
                "Request build failed - check endpoint configuration"
            )

            return AuthError(
                category: .systemError(reason: "요청 생성 실패"),
                message: "Request build failed - check endpoint configuration"
            )
        case .cancelled:
            // 요청된 작업 취소
            return AuthError(category: .operationCancelled)
        case .unknown:
            DebugAssert.fail(
                category: .network,
                "Unknown error - check network configuration"
            )

            return AuthError(
                category: .unknown,
                message: "Unknown error - check network configuration"
            )
        case .unexpected, .notFound:
            DebugAssert.fail(
                category: .network,
                "Unexpected error - fatal error"
            )

            return AuthError(
                category: .unexpected,
                message: "DSError: \(datasourceError.localizedDescription)"
            )
        }
    }
}
