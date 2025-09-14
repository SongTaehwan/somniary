//
//  TokenRepository.swift
//  Somniary
//
//  Created by 송태환 on 9/12/25.
//

import Foundation

// TODO: Register into DIC
// TODO: actor 사용해 리펙토링
final class TokenRepository {

    static let shared = TokenRepository()

    // MARK: Private Props
    private var token: TokenEntity?
    private let storage: KeychainStorage
    private let queueKey = DispatchSpecificKey<Void>()
    private let queueContext: Void = ()
    private let queue = DispatchQueue(
        label: "app.somniary.repository.token.rwlock",
        attributes: .concurrent
    )

    // MARK: 생성자
    init(storage: KeychainStorage = .shared, appLaunchChecker: AppLaunchChecker = .shared) {
        self.storage = storage
        self.queue.setSpecific(key: self.queueKey, value: self.queueContext)

        // 첫 실행이 아니라면 저장된 정보가 있는 경우에만 복원
        if !appLaunchChecker.isFirstLaunch {
            self.restore()
        }
    }

    func restore() {
        if let tokenEntity: TokenEntity = self.storage.retrieve(for: .tokenPair) {
            // RC 방지
            self.queue.async(flags: .barrier) { [weak self] in
                self?.token = tokenEntity
            }
        }
    }

}

// MARK: Getter/Setter
extension TokenRepository {

    /// 저장된 엑세스 토큰 가져오기.
    /// 교착 상황 고려
    func getAccessToken() -> String? {
        if DispatchQueue.getSpecific(key: self.queueKey) != nil {
            return self.token?.accessToken
        }

        return self.queue.sync {
            self.token?.accessToken
        }
    }

    /// 저장된 리프레시 토큰 가져오기.
    func getRefreshToken() -> String? {
        if DispatchQueue.getSpecific(key: self.queueKey) != nil {
            return self.token?.refreshToken
        }

        return self.queue.sync {
            self.token?.refreshToken
        }
    }

    /// 토큰 정보 업데이트
    func updateToken(_ token: TokenEntity) {
        self.queue.async(flags: .barrier) { [weak self] in
            self?.token = token
            self?.storage.save(token, for: .tokenPair)
        }
    }

    /// 저장된 토큰 정보 제거
    func clear() {
        self.queue.async(flags: .barrier) { [weak self] in
            self?.token = nil
            self?.storage.clear(keys: [.tokenPair])
        }
    }
}
