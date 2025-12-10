//
//  CryptoProviding.swift
//  Somniary
//
//  Created by 송태환 on 10/11/25.
//

import Foundation

/// 암호화 관련 기능 제공
protocol CryptoProviding {
    /// 안전한 랜덤 문자열 생성
    func generateSecureRandom(length: Int) -> String

    /// SHA256 해시 생성
    func sha256(_ input: String) -> String
}
