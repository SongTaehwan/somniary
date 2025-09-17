//
//  KeychainStorage.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import KeychainAccess
import Foundation

/// 키체인 전용 에러 타입 (KeyStoringError를 상속)
enum KeychainError: LocalizedError {
    case itemNotFound
    case duplicateItem
    case invalidData
    case accessDenied
    case unexpectedError(String)
    case updateFailed(String)

    // KeyStoringError의 기능도 포함
    case encodingFailed(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "키체인에서 항목을 찾을 수 없습니다"
        case .duplicateItem:
            return "이미 존재하는 항목입니다"
        case .invalidData:
            return "잘못된 데이터 형식입니다"
        case .accessDenied:
            return "키체인 접근이 거부되었습니다"
        case .unexpectedError(let message):
            return "예상치 못한 오류: \(message)"
        case .encodingFailed(let message):
            return "인코딩 실패: \(message)"
        case .decodingFailed(let message):
            return "디코딩 실패: \(message)"
        case .updateFailed(let message):
            return "업데이트 실패: \(message)"
        }
    }
}

final class KeychainStorage<Key>: KeyStoring where Key: RawRepresentable, Key.RawValue == String, Key: CaseIterable, Key.AllCases == [Key] {

    /// 어플리케이션 내 사용되는 키 정의
    typealias ValueKey = Key

    // MARK: Private Props
    private let service: String
    private let queue = DispatchQueue(label: "app.somniary.KeychainStorage.rwlock", attributes: .concurrent)
    private let queueKey = DispatchSpecificKey<Void>()
    private let queueContext: Void = ()

    // MARK: 생성자
    init(service: String = Bundle.main.bundleIdentifier ?? "default.service") {
        self.service = service
        self.queue.setSpecific(key: self.queueKey, value: self.queueContext)
    }

    // MARK: Public methods

    /// 원자성 보장이 필요한 경우 사용 구조체로 저장할 것
    func save<T: Codable>(_ value: T, for key: Key) throws {
        try queue.sync(flags: .barrier) {
            guard let data = try? JSONEncoder().encode(value) else {
                throw KeychainError.encodingFailed("Encoding failed")
            }

            do {
                try Keychain(service: service)
                    .accessibility(.whenUnlocked)
                    .set(data, key: key.rawValue)
            } catch let status as Status {
                switch status {
                case .duplicateItem:
                    try updateExistingItem(data: data, key: key)
                case .authFailed:
                    print("⚠️ 인증 실패: 디바이스 잠금 등")
                    throw KeychainError.accessDenied
                case .interactionNotAllowed:
                    print("⚠️ 상호작용 불가: 백그라운드 상태에서 접근 시도")
                    throw KeychainError.accessDenied
                case .param:
                    print("⚠️ 잘못된 파라미터 전달")
                    throw KeychainError.invalidData
                default:
                    throw KeychainError.unexpectedError(status.localizedDescription)
                }
            } catch {
                throw KeychainError.unexpectedError(error.localizedDescription)
            }
        }
    }

    /// 구조체 불러오기
    func retrieve<T: Decodable>(for key: Key) -> T? {
        // 같은 queue 에서 진입하는 경우
        if DispatchQueue.getSpecific(key: self.queueKey) != nil {
            return self.retrieveData(for: key)
        }

        return queue.sync {
            return self.retrieveData(for: key)
        }
    }

    /// 복수/전체 키 제거
    func clear(keys: [Key] = Key.allCases) {
        queue.sync(flags: .barrier) {
            let keychain = Keychain(service: service).accessibility(.whenUnlocked)
            
            keys.forEach { key in
                keychain[key.rawValue] = nil
            }
        }
    }

    /// 단일 키 제거
    func clear(key: Key) {
        self.clear(keys: [key])
    }

    // MARK: Private Methods

    private func retrieveData<T: Decodable>(for key: Key) -> T? {
        let keychain = Keychain(service: service)
            .accessibility(.whenUnlocked)

        guard let data = try? keychain.getData(key.rawValue) else {
            return nil
        }

        return try? JSONDecoder().decode(T.self, from: data)
    }

    private func updateExistingItem(data: Data, key: Key) throws {
        // 삭제 후 재저장으로 업데이트 구현 (이미 queue.sync 내부에서 호출됨)
        let keychain = Keychain(service: service).accessibility(.whenUnlocked)
        
        // 원자적 업데이트를 위한 단계별 처리
        keychain[key.rawValue] = nil
        
        do {
            try keychain.set(data, key: key.rawValue)    
        } catch {
            throw KeychainError.updateFailed(error.localizedDescription)
        }
    }
}
