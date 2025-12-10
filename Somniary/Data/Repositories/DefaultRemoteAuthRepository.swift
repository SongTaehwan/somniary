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
            throw mapToDomainError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthenticationError.unexpected
        }
    }

    func verify(email: String, otpCode: String, idempotencyKey: String?) async throws -> TokenEntity {
        do {
            let dto = try await self.dataSource.verify(payload: .init(email: email, token: otpCode), idempotencyKey: nil)
            return TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
        } catch let error as RemoteDataSourceError {
            throw mapToDomainError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthenticationError.unexpected
        }
    }

    func verify(credential: AppleCredential, idempotencyKey: String?) async throws -> TokenEntity {
        do {
            let dto = try await self.dataSource.verify(payload: .init(idToken: credential.identityToken, nonce: credential.nonce), idempotencyKey: nil)
            return TokenEntity(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
        } catch let error as RemoteDataSourceError {
            throw mapToDomainError(error)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            throw AuthenticationError.unexpected
        }
    }

    private func mapToDomainError(_ error: Error) -> AuthenticationError {
        guard let datasourceError = error as? RemoteDataSourceError else {
            return AuthenticationError.systemError(reason: error.localizedDescription)
        }

        switch datasourceError {
        case .unauthorized:
            // 인증 필요
            return .authenticationRequired
        case .forbidden:
            // 권한 없음
            return .permissionDenied
        case .notFound:
            // 리소스
            return .resourceNotFound
        case .conflict:
            return .resourceAlreadyExists
        case .networkUnavailable, .timeout:
            // 네트워크
            return .networkUnavailable
        case .serverError:
            // 서버
            return .serverError
        case .emptyResponse:
            // 응답 body가 없음 - 서버 응답 구조 문제
            DebugAssert.fail(category: .network, "Server returned empty response")
            return .serverError
        case .invalidRequest:
            // 클라이언트 버그로 생긴 오류
            return .systemError(reason: "네트워크 요청 오류")
        case .securityError:
            // TLS/인증서 문제 - 클라이언트 또는 서버 설정 문제
            DebugAssert.fail(
                category: .network,
                "Security error - check SSL/TLS configuration"
            )
            return .systemError(reason: "보안 오류")
        case .decodingFailed:
            DebugAssert.fail(category: .network, "Decoding failed")
            return .systemError(reason: "디코딩 실패")
        case .encodingFailed:
            DebugAssert.fail(
                category: .network,
                "Encoding failed - check request model definition"
            )
            return .systemError(reason: "인코딩 실패")
        case .requestBuildFailed:
            DebugAssert.fail(
                category: .network,
                "Request build failed - check endpoint configuration"
            )
            return .systemError(reason: "요청 생성 실패")
        case .cancelled:
            // 요청된 작업 취소
            return .operationCancelled
        case .unknown:
            DebugAssert.fail(
                category: .network,
                "Unknown error - check network configuration"
            )
            return .unknown
        case .unexpected:
            DebugAssert.fail(
                category: .network,
                "Unexpected error - fatal error"
            )
            return .unexpected
        }
    }
}
