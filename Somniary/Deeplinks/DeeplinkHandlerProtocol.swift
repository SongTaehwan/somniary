//
//  DeeplinkHandler.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import Foundation

/// 딥링크를 처리하는 객체 프로토콜
protocol DeeplinkHandlerProtocol {
    /// 입력받은 URL 처리할 수 있는지 판별
    func canOpenURL(_ url: URL) -> Bool
    /// 입력된 URL 에 대한 비즈니스 로직
    func handle(url: URL) -> Void
}
