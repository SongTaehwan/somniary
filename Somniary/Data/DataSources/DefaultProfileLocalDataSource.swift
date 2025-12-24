//
//  DefaultProfileLocalDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

struct DefaultProfileLocalDataSource: ProfileLocalDataSource {
    private let key = "cached.profile.v1"
    private let storage: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.storage = userDefaults
    }

    func load() throws -> NetProfile.Get.Cached? {
        guard let data = storage.data(forKey: key) else { return nil }
        return try JSONDecoder().decode(NetProfile.Get.Cached.self, from: data)
    }

    func save(_ cached: NetProfile.Get.Cached) throws {
        let data = try JSONEncoder().encode(cached)
        storage.set(data, forKey: key)
    }

    func delete() throws {
        storage.removeObject(forKey: key)
    }
}
