//
//  DataSourceSupport.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

/// [check] 호출하는 서버 규약에 따라 개별적인 매핑 로직이 필요
protocol DataSourceSupport {
    func handleTransportResult(_ result: Result<HTTPResponse, TransportError>) -> Result<Void, DataSourceError>
    func handleTransportResult<T: Decodable>(_ result: Result<HTTPResponse, TransportError>) -> Result<T, DataSourceError>
}

extension DataSourceSupport {
    func handleTransportResult(_ result: Result<HTTPResponse, TransportError>) -> Result<Void, DataSourceError> {
        switch result {
        case .failure(let transportError):
            return .failure(mapTransportError(transportError))
        case .success:
            return .success(Void())
        }
    }

    func handleTransportResult<T: Decodable>(_ result: Result<HTTPResponse, TransportError>) -> Result<T, DataSourceError> {
        switch result {
        case .failure(let transportError):
            return .failure(mapTransportError(transportError))
        case .success(let httpResponse):
            return handleHttpResponse(httpResponse)
        }
    }

    /// 응답 데이터를 DTO 로 변환
    private func handleHttpResponse<T: Decodable>(_ httpResponse: HTTPResponse) -> Result<T, DataSourceError> {
        let statusCode = httpResponse.status

        // http 프로토콜 에러 케이스 처리
        guard (200...299).contains(statusCode) else {
            return .failure(self.mapFailureToDataSourceError(httpResponse))
        }

        // 2xx 성공 케이스 처리
        guard let data = httpResponse.body, data.isEmpty == false else {
            return .failure(DataSourceError.response(.emptyResponse))
        }

        // JSON 디코딩
        do {
            let dto = try JSONDecoder.shared.decode(T.self, from: data)
            return .success(dto)
        } catch {
            #if DEBUG
            print("🚨 Decoding failed: \(error)")
            print("📄 Response body: \(data.debugMessage)")
            #endif
            return .failure(DataSourceError.response(.decodingFailed))
        }
    }

    /// 에러 응답 데이터 기반 Data Source Error 매핑
    private func mapFailureToDataSourceError(_ failure: HTTPResponse) -> DataSourceError {
        // 응답 데이터가 없으면 상태 코드로 매핑
        guard let data = failure.body else {
            let error = mapHTTPStatusToError(failure.status)
            #if DEBUG
            print("📄 [Empty Body]: \(error)")
            #endif
            return error
        }

        // 에러 응답 디코딩
        guard let errorDto = try? JSONDecoder.shared.decode(NetError.self, from: data) else {
            let error = mapHTTPStatusToError(failure.status)
            #if DEBUG
            print("📄 [Decoding Failed]: \(error)")
            #endif
            return error
        }

        let error = mapErrorCode(errorDto)

        #if DEBUG
        print("\(errorDto.deubgMessage)")
        print("📄 [DataSourceError]: \(error)")
        #endif
        return error
    }

    /// PostgREST 에러 코드 매핑
    private func mapErrorCode(_ dto: NetError) -> DataSourceError {
        let code = dto.code

        // Group 0
        if code.isConnectionError {
            switch code {
            case .dbConnectionBadUriOrDown,
                 .dbConnectionInternalError,
                 .schemaCacheBuildDbDown:
                // 503
                return .server(.serviceUnavailable)
            case .dbPoolAcquireTimeout:
                // 504
                return .server(.gatewayTimeout)
            default:
                /// 내부 로직 오류로 누락된 것으로 간주
                return .invariantViolation(reason: "Unhandled Connectin Error Code: \(code)")
            }
        }

        // Group 1
        if code.isAPIRequestError {
            switch code {
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
                // 400
                return .client(.invalidRequest)

            case .rpcOnlyGetOrPost,
                 .invalidPutRequest,
                 .httpVerbNotSupported:
                // 405
                return .client(.methodNotAllowed)

            case .invalidRangeForLimits:
                // 416
                return .client(.rangeNotSatisfiable)

            case .invalidContentType:
                // 415
                return .client(.unsupportedMediaType)

            case .invalidPathInUrl,
                 .openApiDisabledApiRootAccessed:
                // 404
                return .resource(.notFound)

            case .singularResponseNotSingleRow:
                // 406
                return .resource(.notSingular)

            case .schemaNotAllowedInDbSchemas:
                // 406 (정확히는 Not Acceptable 성격)
                // ClientReason.notAcceptable 같은 케이스를 추가하면 더 정밀해짐
                return .client(.invalidRequest)

            case .invalidResponseHeadersGuc,
                 .invalidResponseStatusGuc,
                 .raisePgrstJsonParseFailed:
                // 500 (PostgREST 설정/서버 내부 문제에 가까움)
                return .server(.dbError)
            default:
                return .invariantViolation(reason: "Unhandled API Request Error Code: \(code)")
            }
        }

        // Group 2
        if code.isSchemaCacheError {
            switch code {
            case .schemaCacheStaleRelationshipOrMissing,
                 .columnsParamColumnNotFound:
                // 400
                return .client(.invalidRequest)

            case .ambiguousEmbedding,
                 .overloadedFunctionAmbiguous:
                // 300 (Multiple Choices / ambiguity)
                // 클라가 select/호출을 더 명확히 해야 하는 “요청 명세 문제”로 보고 invalidRequest로 처리 추천
                return .client(.invalidRequest)

            case .schemaCacheFunctionNotFound,
                 .schemaCacheTableNotFound:
                // 404
                return .resource(.notFound)
            default:
                return .invariantViolation(reason: "Unhandled Schema Cache Error Code: \(code)")
            }
        }

        // Group 3
        if code.isJwtError {
            switch code {
            case .jwtInvalid:
                // 401 (expired 포함)
                return .unauthorized(.tokenExpired)
            case .jwtClaimsInvalid:
                // 401 (claim이 잘못됨 = 토큰이 유효하지 않음)
                return .unauthorized(.invalidToken)
            case .bearerAuthRequiredAnonDisabled:
                // 401 (자격 증명 자체가 없거나 요구됨)
                return .unauthorized(.unauthorized)
            case .jwtSecretMissing:
                // 500 (서버 설정 문제)
                return .server(.serverError)
            default:
                return .invariantViolation(reason: "Unhandled JWT Error Code: \(code)")
            }

        }

        // Group X
        if code.isInternalServerError {
            return .server(.serverError)
        }

        if code.isDBError {
            switch code {
            case .foreignKeyViolation,
                 .uniqueViolation:
                // 409
                return .resource(.conflict)

            case .readOnlySqlTransaction:
                // 405
                return .client(.methodNotAllowed)

            case .undefinedFunction,
                 .undefinedTable:
                // 404
                return .resource(.notFound)

            case .infiniteRecursion:
                // 500
                return .server(.dbError)

            case .insufficientPrivilege:
                // 42501 (401/403로 내려올 수 있음)
                // 보통은 403(권한 부족)로 보는 게 자연스러워서 forbidden
                return .forbidden(.resourceForbidden)
            case .raiseDefault:
                // P0001 (400)
                return .client(.invalidRequest)

            case .postgres:
                // 기타 SQLSTATE: 의미를 모르면 보수적으로 dbError로 분류(서버/DB 계층 문제)
                return .server(.dbError)
            default:
                return .invariantViolation(reason: "Unhandled PostgresQL Error Code: \(code)")
            }
        }

        switch code {
        case .customStatus(let status):
            return mapHTTPStatusToError(status)
        case .unknown(let reason):
            return DataSourceError.invariantViolation(reason: reason)
        default:
            DebugAssert.fail(category: .network, severity: .critical, dto.deubgMessage)
            return DataSourceError.invariantViolation(reason: "failed to handle Error Code: \(code)")
        }
    }

    /// 책임: 네트워크 프로토콜 해석
    /// body.code 파싱하여 PostgREST 응답 코드 매핑
    private func mapHTTPStatusToError(_ status: Int) -> DataSourceError {
        switch status {
        case 401: return .unauthorized(.unauthorized)
        case 403: return .forbidden(.forbidden)
        case 404: return .resource(.notFound)
        case 405: return .client(.methodNotAllowed)
        case 409: return .resource(.conflict)
        case 415: return .client(.unsupportedMediaType)
        case 416: return .client(.rangeNotSatisfiable)
        case 400, 406, 422: return .client(.invalidRequest)
        case 500: return .server(.serverError)
        case 502: return .server(.badGateway)
        case 503: return .server(.serviceUnavailable)
        case 504: return .server(.gatewayTimeout)
        default:
            if (500...599).contains(status) {
                return .server(.serverError)
            }

            if (400...499).contains(status) {
                return .client(.invalidRequest)
            }

            DebugAssert.fail(category: .network, "Unhandled status code: \(status)")
            return .invariantViolation(reason: "Unhandled status code: \(status)")
        }
    }

    /// 책임: 네트워크 전송 에러 해석
    private func mapTransportError(_ error: TransportError) -> DataSourceError {
        switch error {
        case .requestBuildFailed:
            return .client(.invalidRequest)
        case .tls, .network, .cancelled:
            return .transport(error)
        case .unknown:
            return .invariantViolation(reason: error.localizedDescription)
        }
    }
}
