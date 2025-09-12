//
//  KeychainStorage.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import KeychainAccess
import Foundation

final class KeychainStorage: KeyStoring {

    static let shared = KeychainStorage()

    /// 어플리케이션 내 사용되는 키 정의
    enum ValueKey: String, CaseIterable {
        case accessToken
        case refreshToken
    }

    private let service: String

    init(service: String = Bundle.main.bundleIdentifier ?? "default.service") {
        self.service = service
    }

    /// 키 값 저장
    func save(_ value: String, for key: ValueKey) {
        do {
            try Keychain(service: service)
                .accessibility(.whenUnlocked)
                .set(value, key: key.rawValue)
        } catch let status as Status {
            // KeychainAccess에서 제공하는 OSStatus 래핑 타입
            // TODO: Logger 로 전환
            switch status {
            case .duplicateItem:
                print("⚠️ Duplicate item: 이미 같은 키 값이 있음")
            case .authFailed:
                print("⚠️ 인증 실패: 디바이스 잠금 등")
            case .interactionNotAllowed:
                print("⚠️ 상호작용 불가: 백그라운드 상태에서 접근 시도")
            case .param:
                print("⚠️ 잘못된 파라미터 전달")
            default:
                print("⚠️ 알 수 없는 Keychain 에러: \(status)")
            }
        } catch {
            print("⚠️ 기타 오류: \(error)")
        }
    }

    /// 저장된 값 불러오기
    func retrieve(for key: ValueKey) -> String? {
        let keychain = Keychain(service: service)
            .accessibility(.whenUnlocked)
        return try? keychain.get(key.rawValue)
    }

    /// 복수/전체 키 제거
    func clear(keys: [ValueKey] = ValueKey.allCases) {
        let keychain = Keychain(service: service).accessibility(.whenUnlocked)

        keys.forEach { key in
            keychain[key.rawValue] = nil
        }
    }

    /// 단일 키 제거
    func clear(key: ValueKey) {
        self.clear(keys: [key])
    }
}
