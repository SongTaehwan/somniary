//
//  LocalStorage.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

final class LocalStorage: KeyStoring {
    static let shared = LocalStorage()

    enum ValueKey: String, CaseIterable {
        // TODO: 로컬 저장소에 저장할 키 정의
        case accessToken
        case refreshToken
    }
}
