//
//  NavigationController.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

/// NavigationStack 상태 관리 객체
final class NavigationController<Route: Routable>: ObservableObject {
    /// 네비게이션 화면 스택
    @Published var path = NavigationPath()

    /// Overlay 라우트 (NavigationType.present)
    @Published var presentedRoute: Route?

    /// Overlay 화면을 닫을 때 호출됨
    private let onDismissPresentedRoute: (NavigationController) -> Void

    var routesCount: Int {
        self.path.count
    }

    // MARK: 생성자
    init(onDissmissPresentedRoute: @escaping (NavigationController) -> Void) {
        self.onDismissPresentedRoute = onDissmissPresentedRoute
    }

    func addRoute(_ route: Route) {
        self.path.append(route)
    }

    func removeLastRoute() {
        self.path.removeLast()
    }

    func removeAllRoutes() {
        self.path.removeLast(self.path.count)
    }

    /// sheet, fullScreenCover 를 노출시키는데 사용됨.
    /// presentedRoute 값 할당 시  매개변수와 presentedRoute 내 PresentationType 이 일치하는 경우
    /// sheet 또는 fullScreenCover 를 화면에 노출시킴
    func isPresnting(with type: PresentationType) -> Binding<Bool> {
        return Binding<Bool> { [weak self] in
            guard let currentType = self?.presentedRoute?.navigationType.presentationType else {
                return false
            }

            return currentType == type
        } set: { [weak self] newValue in
            // isPresenting = false 가 될때 실행
            guard let self, !newValue else { return }
            self.presentedRoute = nil
            // 상위 전파
            self.onDismissPresentedRoute(self)
        }

    }
}
