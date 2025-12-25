//
//  DefaultRemoteProfileDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct DefaultProfileRemoteDataSource: ProfileRemoteDataSource, DataSourceSupport {
    private let client: HTTPClient<UserEndpoint>

    init(client: HTTPClient<UserEndpoint>) {
        self.client = client
    }

    func fetchProfile() async -> Result<NetProfile.Get.Response, RemoteDataSourceError> {
        let httpResult = await client.request(.getProfile)
            .mapError(self.mapTransportError(_:))

        return Result.catching {
            try decodeHttpResult(httpResult)
        } mapError: { error in
            if let dsError = error as? RemoteDataSourceError {
                return dsError
            } else {
                return .cancelled
            }
        }
    }

    func updateProfile(id: String, payload: NetProfile.Update.Request) async -> Result<NetProfile.Get.Response, RemoteDataSourceError> {
        let httpResult = await client.request(.update(id: id, payload: payload))
            .mapError(self.mapTransportError(_:))

        return Result.catching {
            let httpResponse = try handleHttpResult(httpResult)

            guard (200...299).contains(httpResponse.status) else {
                throw self.mapToDataSourceError(httpResponse)
            }

            return try decodeHttpResult(httpResult)
        } mapError: { error in
            if let dsError = error as? RemoteDataSourceError {
                return dsError
            } else {
                return .cancelled
            }
        }
    }

    func mapToDataSourceError(_ response: HTTPResponse) -> RemoteDataSourceError {
        guard (200...299).contains(response.status) == false else {
            DebugAssert.fail(category: .logic, "20x 케이스에서 에러 매핑 함수 호출: \(#function)")
            return RemoteDataSourceError.unexpected
        }

        guard let body = response.body else {
            return self.mapHTTPStatusToError(response.status)
        }

        do {
            let payload = try JSONDecoder().decode(NetError.self, from: body)
            return self.mapErrorCodeToDataSourceError(payload.code)
        } catch {
            DebugAssert.fail(category: .network, "Unexpected error: \(error)")
            return RemoteDataSourceError.unexpected
        }
    }

    func mapErrorCodeToDataSourceError(_ code: NetErrorCode) -> RemoteDataSourceError {
        guard let statusCode = code.httpStatusHint else {
            DebugAssert.fail(category: .network, "httpStatusHint가 nil인 NetErrorCode: \(code.rawCode)")
            return .unknown
        }

        if code.isConnectionError || code.isInternalServerError {
            return RemoteDataSourceError.serverError
        }

        if code.isDBError {
            return RemoteDataSourceError.dbError
        }

        if code.isJwtError {
            switch code {
            // 401 - Unauthorized (인증 실패)
            case .jwtInvalid:
                // JWT 만료 또는 무효한 토큰
                return .tokenExpired
            case .jwtClaimsInvalid:
                // JWT 클레임이 유효하지 않음
                return .invalidToken
            case .bearerAuthRequiredAnonDisabled:
                // Bearer 토큰이 필요하지만 제공되지 않음
                return .unauthorized
            // 500 - Internal Server Error (서버 설정 문제)
            case .jwtSecretMissing:
                // JWT 시크릿이 서버에 설정되지 않음
                return .serverError
            default:
                return .unexpected
            }
        }

        if code.isAPIRequestError {
            switch code {
            // 400 - Bad Request (잘못된 요청)
            case .queryStringParseError,
                .invalidRequestBody,
                .embedFilterWithoutSelect,
                .upsertPutWithLimitsOffsets,
                .upsertPutPrimaryKeyMismatch,
                .orderByRelatedNoRelationship,
                .embedFilterOnlyNullOperators,
                .preferHandlingStrictInvalid,
                .aggregatesDisabled,
                .preferMaxAffectedViolated,
                .featureNotImplemented,
                .preferMaxAffectedViolatedRpc:
                return .invalidRequest
            
            // 404 - Not Found (리소스를 찾을 수 없음)
            case .invalidPathInUrl,
                .openApiDisabledApiRootAccessed:
                return .resourceNotFound
            
            // 405 - Method Not Allowed (HTTP 메서드 불가)
            case .rpcOnlyGetOrPost,
                .invalidPutRequest,
                .httpVerbNotSupported:
                return .methodNotAllowed
            
            // 406 - Not Acceptable (리소스가 단일이 아님)
            case .schemaNotAllowedInDbSchemas,
                .singularResponseNotSingleRow:
                return .resouceNotSingular
            
            // 415 - Unsupported Media Type
            case .invalidContentType:
                return .unsupportedMediaType
            
            // 416 - Range Not Satisfiable
            case .invalidRangeForLimits:
                return .rangeNotSatisfiable
            
            // 500 - Internal Server Error
            case .invalidResponseHeadersGuc,
                .invalidResponseStatusGuc,
                .raisePgrstJsonParseFailed:
                return .serverError
            
            default:
                return .unexpected
            }
        }

        return .unexpected
    }
}
