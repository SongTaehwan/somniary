//
//  JSONDecoder+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 1/13/26.
//

import Foundation

extension JSONDecoder {
    /// JSONDecoder 싱글톤 객체
    ///
    /// ISO 8601 형식의 날짜 문자열을 파싱하여 Swift의 Date 타입으로 변환합니다.
    ///
    /// - Note: Fractional seconds를 포함한 형식을 지원합니다.
    /// - Important: 문자열에 타임존 정보가 반드시 포함되어야 합니다.
    /// - Throws: 잘못된 형식의 문자열은 에러를 발생시킵니다.
    static let shared = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            if let date = formatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        })

        return decoder
    }()
}
