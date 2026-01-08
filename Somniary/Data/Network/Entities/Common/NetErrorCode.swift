//
//  NetErrorCode.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

// https://docs.postgrest.org/en/v14/references/errors.html#postgrest-error-codes
enum NetErrorCode: Equatable, Sendable, Error, Decodable {
    // ================
    // PostgREST (PGRST)
    // ================
    // Group 0 - Connection  [oai_citation:1‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case dbConnectionBadUriOrDown            // PGRST000 (503)
    case dbConnectionInternalError           // PGRST001 (503)
    case schemaCacheBuildDbDown              // PGRST002 (503)
    case dbPoolAcquireTimeout                // PGRST003 (504)

    // Group 1 - API Request  [oai_citation:2‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case queryStringParseError               // PGRST100 (400)
    case rpcOnlyGetOrPost                    // PGRST101 (405)
    case invalidRequestBody                  // PGRST102 (400)
    case invalidRangeForLimits               // PGRST103 (416)
    case invalidPutRequest                   // PGRST105 (405)
    case schemaNotAllowedInDbSchemas         // PGRST106 (406)
    case invalidContentType                  // PGRST107 (415)
    case embedFilterWithoutSelect            // PGRST108 (400)
    case invalidResponseHeadersGuc           // PGRST111 (500)
    case invalidResponseStatusGuc            // PGRST112 (500)
    case upsertPutWithLimitsOffsets          // PGRST114 (400)
    case upsertPutPrimaryKeyMismatch         // PGRST115 (400)
    case singularResponseNotSingleRow        // PGRST116 (406)
    case httpVerbNotSupported                // PGRST117 (405)
    case orderByRelatedNoRelationship        // PGRST118 (400)
    case embedFilterOnlyNullOperators         // PGRST120 (400)
    case raisePgrstJsonParseFailed           // PGRST121 (500)
    case preferHandlingStrictInvalid         // PGRST122 (400)
    case aggregatesDisabled                  // PGRST123 (400)
    case preferMaxAffectedViolated           // PGRST124 (400)
    case invalidPathInUrl                    // PGRST125 (404)
    case openApiDisabledApiRootAccessed      // PGRST126 (404)
    case featureNotImplemented               // PGRST127 (400)
    case preferMaxAffectedViolatedRpc        // PGRST128 (400)

    // Group 2 - Schema Cache  [oai_citation:3‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case schemaCacheStaleRelationshipOrMissing // PGRST200 (400)
    case ambiguousEmbedding                  // PGRST201 (300)
    case schemaCacheFunctionNotFound         // PGRST202 (404)
    case overloadedFunctionAmbiguous         // PGRST203 (300)
    case columnsParamColumnNotFound          // PGRST204 (400)
    case schemaCacheTableNotFound            // PGRST205 (404)

    // Group 3 - JWT  [oai_citation:4‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case jwtSecretMissing                    // PGRST300 (500)
    case jwtInvalid                          // PGRST301 (401)  <-- "JWT expired"도 여기에 포함
    case bearerAuthRequiredAnonDisabled      // PGRST302 (401)
    case jwtClaimsInvalid                    // PGRST303 (401)

    // Group X - Internal  [oai_citation:5‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case internalDbLibraryError              // PGRSTX00 (500)

    // PostgreSQL (SQLSTATE)
    case foreignKeyViolation                 // 23503 (409)
    case uniqueViolation                     // 23505 (409)
    case readOnlySqlTransaction              // 25006 (405)
    case undefinedFunction                   // 42883 (404)
    case undefinedTable                      // 42P01 (404)
    case infiniteRecursion                   // 42P17 (500)
    case insufficientPrivilege               // 42501 (401/403 depending auth)
    case raiseDefault                        // P0001 (400)
    case postgres(sqlstate: String)          // 기타 SQLSTATE

    // Custom / Fallback
    case customStatus(Int)                   // PTxyz (예: PT402)  [oai_citation:6‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
    case unknown(String)

    // MARK: Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = NetErrorCode(codeString: raw)
    }

    // MARK: Mapping
    init(codeString raw: String) {
        switch raw {
        // PGRST Group 0
        case "PGRST000": self = .dbConnectionBadUriOrDown
        case "PGRST001": self = .dbConnectionInternalError
        case "PGRST002": self = .schemaCacheBuildDbDown
        case "PGRST003": self = .dbPoolAcquireTimeout

        // PGRST Group 1
        case "PGRST100": self = .queryStringParseError
        case "PGRST101": self = .rpcOnlyGetOrPost
        case "PGRST102": self = .invalidRequestBody
        case "PGRST103": self = .invalidRangeForLimits
        case "PGRST105": self = .invalidPutRequest
        case "PGRST106": self = .schemaNotAllowedInDbSchemas
        case "PGRST107": self = .invalidContentType
        case "PGRST108": self = .embedFilterWithoutSelect
        case "PGRST111": self = .invalidResponseHeadersGuc
        case "PGRST112": self = .invalidResponseStatusGuc
        case "PGRST114": self = .upsertPutWithLimitsOffsets
        case "PGRST115": self = .upsertPutPrimaryKeyMismatch
        case "PGRST116": self = .singularResponseNotSingleRow
        case "PGRST117": self = .httpVerbNotSupported
        case "PGRST118": self = .orderByRelatedNoRelationship
        case "PGRST120": self = .embedFilterOnlyNullOperators
        case "PGRST121": self = .raisePgrstJsonParseFailed
        case "PGRST122": self = .preferHandlingStrictInvalid
        case "PGRST123": self = .aggregatesDisabled
        case "PGRST124": self = .preferMaxAffectedViolated
        case "PGRST125": self = .invalidPathInUrl
        case "PGRST126": self = .openApiDisabledApiRootAccessed
        case "PGRST127": self = .featureNotImplemented
        case "PGRST128": self = .preferMaxAffectedViolatedRpc

        // PGRST Group 2
        case "PGRST200": self = .schemaCacheStaleRelationshipOrMissing
        case "PGRST201": self = .ambiguousEmbedding
        case "PGRST202": self = .schemaCacheFunctionNotFound
        case "PGRST203": self = .overloadedFunctionAmbiguous
        case "PGRST204": self = .columnsParamColumnNotFound
        case "PGRST205": self = .schemaCacheTableNotFound

        // PGRST Group 3
        case "PGRST300": self = .jwtSecretMissing
        case "PGRST301": self = .jwtInvalid
        case "PGRST302": self = .bearerAuthRequiredAnonDisabled
        case "PGRST303": self = .jwtClaimsInvalid

        // PGRST Group X
        case "PGRSTX00": self = .internalDbLibraryError

        // PostgreSQL common SQLSTATE
        case "23503": self = .foreignKeyViolation
        case "23505": self = .uniqueViolation
        case "25006": self = .readOnlySqlTransaction
        case "42883": self = .undefinedFunction
        case "42P01": self = .undefinedTable
        case "42P17": self = .infiniteRecursion
        case "42501": self = .insufficientPrivilege
        case "P0001": self = .raiseDefault

        default:
            // PTxyz (custom status)  [oai_citation:7‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
            if raw.hasPrefix("PT"),
               let status = Int(raw.dropFirst(2)),
               (100...599).contains(status) {
                self = .customStatus(status)
                return
            }

            // 기타 SQLSTATE는 보통 5자리(문자/숫자 혼합)인 점을 감안해 postgres로 분류
            if raw.count == 5 {
                self = .postgres(sqlstate: raw)
            } else {
                self = .unknown(raw)
            }
        }
    }

    // MARK: Helpers
    var rawCode: String {
        switch self {
        // PGRST Group 0
        case .dbConnectionBadUriOrDown: return "PGRST000"
        case .dbConnectionInternalError: return "PGRST001"
        case .schemaCacheBuildDbDown: return "PGRST002"
        case .dbPoolAcquireTimeout: return "PGRST003"

        // PGRST Group 1
        case .queryStringParseError: return "PGRST100"
        case .rpcOnlyGetOrPost: return "PGRST101"
        case .invalidRequestBody: return "PGRST102"
        case .invalidRangeForLimits: return "PGRST103"
        case .invalidPutRequest: return "PGRST105"
        case .schemaNotAllowedInDbSchemas: return "PGRST106"
        case .invalidContentType: return "PGRST107"
        case .embedFilterWithoutSelect: return "PGRST108"
        case .invalidResponseHeadersGuc: return "PGRST111"
        case .invalidResponseStatusGuc: return "PGRST112"
        case .upsertPutWithLimitsOffsets: return "PGRST114"
        case .upsertPutPrimaryKeyMismatch: return "PGRST115"
        case .singularResponseNotSingleRow: return "PGRST116"
        case .httpVerbNotSupported: return "PGRST117"
        case .orderByRelatedNoRelationship: return "PGRST118"
        case .embedFilterOnlyNullOperators: return "PGRST120"
        case .raisePgrstJsonParseFailed: return "PGRST121"
        case .preferHandlingStrictInvalid: return "PGRST122"
        case .aggregatesDisabled: return "PGRST123"
        case .preferMaxAffectedViolated: return "PGRST124"
        case .invalidPathInUrl: return "PGRST125"
        case .openApiDisabledApiRootAccessed: return "PGRST126"
        case .featureNotImplemented: return "PGRST127"
        case .preferMaxAffectedViolatedRpc: return "PGRST128"

        // PGRST Group 2
        case .schemaCacheStaleRelationshipOrMissing: return "PGRST200"
        case .ambiguousEmbedding: return "PGRST201"
        case .schemaCacheFunctionNotFound: return "PGRST202"
        case .overloadedFunctionAmbiguous: return "PGRST203"
        case .columnsParamColumnNotFound: return "PGRST204"
        case .schemaCacheTableNotFound: return "PGRST205"

        // PGRST Group 3
        case .jwtSecretMissing: return "PGRST300"
        case .jwtInvalid: return "PGRST301"
        case .bearerAuthRequiredAnonDisabled: return "PGRST302"
        case .jwtClaimsInvalid: return "PGRST303"

        // PGRST Group X
        case .internalDbLibraryError: return "PGRSTX00"

        // PostgreSQL SQLSTATE
        case .foreignKeyViolation: return "23503"
        case .uniqueViolation: return "23505"
        case .readOnlySqlTransaction: return "25006"
        case .undefinedFunction: return "42883"
        case .undefinedTable: return "42P01"
        case .infiniteRecursion: return "42P17"
        case .insufficientPrivilege: return "42501"
        case .raiseDefault: return "P0001"
        case .postgres(let s): return s

        // Custom / fallback
        case .customStatus(let status): return "PT\(status)"
        case .unknown(let s): return s
        }
    }

    /// (선택) 문서 기반 status 힌트(라우팅/리트라이/로그 분류 등에 사용)
    var httpStatusHint: Int? {
        switch self {
        // PGRST Group 0  [oai_citation:8‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
        case .dbConnectionBadUriOrDown, .dbConnectionInternalError, .schemaCacheBuildDbDown: return 503
        case .dbPoolAcquireTimeout: return 504

        // PGRST Group 1  [oai_citation:9‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
        case .rpcOnlyGetOrPost, .invalidPutRequest, .httpVerbNotSupported: return 405
        case .invalidRangeForLimits: return 416
        case .schemaNotAllowedInDbSchemas, .singularResponseNotSingleRow: return 406
        case .invalidContentType: return 415
        case .invalidResponseHeadersGuc, .invalidResponseStatusGuc, .raisePgrstJsonParseFailed: return 500
        case .invalidPathInUrl, .openApiDisabledApiRootAccessed: return 404
        default:
            // Group 1에서 나머지는 대부분 400
            if rawCode.hasPrefix("PGRST1") { return 400 }

            // PGRST Group 2  [oai_citation:10‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
            if rawCode == "PGRST201" || rawCode == "PGRST203" { return 300 }
            if rawCode == "PGRST202" || rawCode == "PGRST205" { return 404 }
            if rawCode == "PGRST200" || rawCode == "PGRST204" { return 400 }

            // PGRST Group 3  [oai_citation:11‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
            if rawCode == "PGRST300" { return 500 }
            if rawCode == "PGRST301" || rawCode == "PGRST302" || rawCode == "PGRST303" { return 401 }

            // PGRST Group X  [oai_citation:12‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
            if rawCode == "PGRSTX00" { return 500 }

            // PostgreSQL common mapping(문서에 정의)  [oai_citation:13‡PostgREST 14](https://docs.postgrest.org/en/v14/_sources/references/errors.rst.txt)
            switch self {
            case .foreignKeyViolation, .uniqueViolation: return 409
            case .readOnlySqlTransaction: return 405
            case .undefinedFunction, .undefinedTable: return 404
            case .infiniteRecursion: return 500
            case .raiseDefault: return 400
            case .insufficientPrivilege: return nil // 401/403은 “인증 여부”에 따라 달라서 힌트 생략
            default: break
            }

            // Custom status
            if case .customStatus(let s) = self { return s }

            return nil
        }
    }
}

extension NetErrorCode {
    /// Group 0 - Connection
    var isConnectionError: Bool {
        switch self {
        case .dbConnectionBadUriOrDown,       // PGRST000 (503)
             .dbConnectionInternalError,      // PGRST001 (503)
             .schemaCacheBuildDbDown,         // PGRST002 (503)
             .dbPoolAcquireTimeout:           // PGRST003 (504)
            return true
        default:
            return false
        }
    }

    /// Group 1 - API Request
    var isAPIRequestError: Bool {
        switch self {
        case .queryStringParseError,          // PGRST100 (400)
             .rpcOnlyGetOrPost,               // PGRST101 (405)
             .invalidRequestBody,             // PGRST102 (400)
             .invalidRangeForLimits,          // PGRST103 (416)
             .invalidPutRequest,              // PGRST105 (405)
             .schemaNotAllowedInDbSchemas,    // PGRST106 (406)
             .invalidContentType,             // PGRST107 (415)
             .embedFilterWithoutSelect,       // PGRST108 (400)
             .invalidResponseHeadersGuc,      // PGRST111 (500)
             .invalidResponseStatusGuc,       // PGRST112 (500)
             .upsertPutWithLimitsOffsets,     // PGRST114 (400)
             .upsertPutPrimaryKeyMismatch,    // PGRST115 (400)
             .singularResponseNotSingleRow,   // PGRST116 (406)
             .httpVerbNotSupported,           // PGRST117 (405)
             .orderByRelatedNoRelationship,   // PGRST118 (400)
             .embedFilterOnlyNullOperators,   // PGRST120 (400)
             .raisePgrstJsonParseFailed,      // PGRST121 (500)
             .preferHandlingStrictInvalid,    // PGRST122 (400)
             .aggregatesDisabled,             // PGRST123 (400)
             .preferMaxAffectedViolated,      // PGRST124 (400)
             .invalidPathInUrl,               // PGRST125 (404)
             .openApiDisabledApiRootAccessed, // PGRST126 (404)
             .featureNotImplemented,          // PGRST127 (400)
             .preferMaxAffectedViolatedRpc:   // PGRST128 (400)
            return true
        default:
            return false
        }
    }

    /// Group 2 - Schema Cache
    var isSchemaCacheError: Bool {
        switch self {
        case .schemaCacheStaleRelationshipOrMissing,  // PGRST200 (400) 
             .ambiguousEmbedding,                     // PGRST201 (300)  
             .schemaCacheFunctionNotFound,            // PGRST202 (404)
             .overloadedFunctionAmbiguous,            // PGRST203 (300)
             .columnsParamColumnNotFound,             // PGRST204 (400)
             .schemaCacheTableNotFound:               // PGRST205 (404) 
            return true
        default:
            return false
        }
    }

    /// Group 3 - JWT Error
    var isJwtError: Bool {
        switch self {
        case .jwtSecretMissing,                      // PGRST300 (500)
             .jwtInvalid,                            // PGRST301 (401)
             .bearerAuthRequiredAnonDisabled,        // PGRST302 (401)
             .jwtClaimsInvalid:                      // PGRST303 (401)
            return true
        default:
            return false
        }
    }

    /// Group X
    var isInternalServerError: Bool {
        return self == .internalDbLibraryError      // PGRSTX00 (500)
    }

    /// PostgreSQL (SQLSTATE)
    var isDBError: Bool {
        switch self {
        case .foreignKeyViolation,                  // 23503 (409)
             .uniqueViolation,                      // 23505 (409)
             .readOnlySqlTransaction,               // 25006 (405)
             .undefinedTable,                       // 42P01 (404)
             .undefinedFunction,                    // 42883 (404)
             .infiniteRecursion,                    // 42P17 (500)
             .insufficientPrivilege,                // 42501 (401/403 depending auth)
             .raiseDefault,                         // P0001 (400)
             .postgres:                             // 기타 SQLSTATE (5자리)
            return true
        default:
            return false
        }
    }
}
