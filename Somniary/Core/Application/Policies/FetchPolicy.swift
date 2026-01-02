//
//  FetchPolicy.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

enum FetchPolicy {
    case cacheFirst      // 캐시 있으면 사용
    case remoteIfStale   // stale이면 원격 갱신
    case remoteOnly      // 무조건 원격
}
