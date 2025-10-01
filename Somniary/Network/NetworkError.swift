//
//  NetworkError.swift
//  Somniary
//
//  Created by 송태환 on 10/1/25.
//

import Foundation

/// 네트워크 요청 중 발생할 수 있는 에러 정의
enum NetworkError: Error {
    /// HTTP 상태 코드 에러 (4xx, 5xx)
    case httpError(Int)
    
    /// JSON 디코딩 실패
    case decodingError(Error)

    /// 네트워크 연결 실패 (인터넷 연결 없음, 타임아웃 등)
    case networkError(Error)

    /// 잘못된 URL 또는 요청 구성 에러
    case invalidRequest

    /// 인증 실패 (401, 403)
    case unauthorized

    /// 서버 에러 (5xx)
    case serverError(Int)

    /// 알 수 없는 에러
    case unknown
}

extension NetworkError: LocalizedError {
    /// 사용자에게 표시할 에러 메시지
    var errorDescription: String? {
        switch self {
        case .httpError(let statusCode):
            return "HTTP 에러가 발생했습니다. (상태 코드: \(statusCode))"

        case .decodingError:
            return "응답 데이터를 처리하는 중 오류가 발생했습니다."

        case .networkError:
            return "네트워크 연결에 실패했습니다. 인터넷 연결을 확인해주세요."

        case .invalidRequest:
            return "잘못된 요청입니다."

        case .unauthorized:
            return "인증에 실패했습니다. 다시 로그인해주세요."

        case .serverError(let statusCode):
            return "서버 오류가 발생했습니다. (상태 코드: \(statusCode))"

        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

extension NetworkError {
    /// HTTP 상태 코드로부터 적절한 NetworkError 생성
    static func from(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401, 403:
            return .unauthorized

        case 400..<500:
            return .httpError(statusCode)

        case 500..<600:
            return .serverError(statusCode)

        default:
            return .httpError(statusCode)
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.httpError(let lCode), .httpError(let rCode)):
            return lCode == rCode

        case (.decodingError, .decodingError):
            return true

        case (.networkError, .networkError):
            return true

        case (.invalidRequest, .invalidRequest):
            return true

        case (.unauthorized, .unauthorized):
            return true

        case (.serverError(let lCode), .serverError(let rCode)):
            return lCode == rCode

        case (.unknown, .unknown):
            return true

        default:
            return false
        }
    }
}
