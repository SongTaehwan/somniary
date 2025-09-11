//
//  DeeplinkCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import Foundation

final class DeeplinkCoordinator {
    private var handlers: [DeeplinkHandlerProtocol]

    init(handlers: [DeeplinkHandlerProtocol] = []) {
        self.handlers = handlers
    }

    func addHandlers(_ handlers: [DeeplinkHandlerProtocol]) {
        self.handlers.append(contentsOf: handlers)
    }

    /// 해당 URL 을 처리할 수 있는 Handler 를 찾아 딥링크 처리를 위임
    func handle(_ url: URL) {
        guard let handler = self.handlers.first(where: { $0.canOpenURL(url) }) else {
            return
        }

        handler.handle(url: url)
    }
}
