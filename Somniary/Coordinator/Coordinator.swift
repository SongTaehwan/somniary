//
//  CoordinatorProtocol.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

protocol CoordinatorFinishDelegate: AnyObject {

    func didFinish(childCoordinator: any Coordinator)
}

protocol Coordinator: ObservableObject, CoordinatorFinishDelegate {

    associatedtype Content: View

    /// Flow 의 시작점이자 NavigationStack 이 포함되어야함
    @MainActor @ViewBuilder var rootView: Content { get }

    /// 플로우 종료 함수 호출 시 상위에서 처리를 위임
    var finishDelegate: CoordinatorFinishDelegate? { get set }

    func finish()
}

extension Coordinator {

    func finish() {
        self.finishDelegate?.didFinish(childCoordinator: self)
    }
}
