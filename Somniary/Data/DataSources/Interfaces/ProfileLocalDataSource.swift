//
//  ProfileLocalDataSource.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

protocol ProfileLocalDataSource {
    func load() throws -> NetProfile.Get.Cached?
    func save(_ cached: NetProfile.Get.Cached) throws
    func delete() throws
}
