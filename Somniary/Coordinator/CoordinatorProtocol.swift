//
//  CoordinatorProtocol.swift
//  Somniary
//
//  Created by 송태환 on 9/10/25.
//

import SwiftUI

protocol Coordinator: ObservableObject {

    associatedtype Content: View

    /// Flow 의 시작점이자 NavigationStack 이 포함되어야함
    @MainActor @ViewBuilder var rootView: Content { get }
}

/// Flow 정의 및 라우팅 처리 담당 Coordinator
protocol FlowCoordinator: Coordinator {

    associatedtype Route: Routable
    associatedtype Destination: View

    /// sheet, fullScreenCover 로 인해 Nested navigation stack 구조를 가질 수 있기 때문에 배열로 상태 객체를 저장
    var navigationControllers: [NavigationController<Route>] { get set }

    /// 라우팅 분기점
    @MainActor @ViewBuilder func destination(for route: Route) -> Destination
}

extension FlowCoordinator {

    /// 인스턴스 생성 시 Root navigation controller 추가
    func initializeRootNavigationController() {
        guard self.navigationControllers.count == 0 else {
            return
        }

        self.navigationControllers.append(
            NavigationController { [weak self] navigationController in
                self?.dismissNavigationController(navigationController)
            }
        )
    }

    // MARK: 화면 전환 관련
    /// 화면 추가
    func push(route: Route) {
        topNavigationController.addRoute(route)
    }

    /// 화면 뒤로가기
    func pop() {
        let isRouteExist = topNavigationController.routesCount > 0
        guard isRouteExist else { return }
        topNavigationController.removeLastRoute()
    }

    /// 첫 화면으로 돌아가기
    func popToRoot() {
        let isRouteExist = topNavigationController.routesCount > 0
        guard isRouteExist else { return }
        topNavigationController.removeAllRoutes()
    }

    // MARK: Present 전환 관련
    /// Presentation flow 노출
    /// sheet, fullScreenCover flow 의 소유자는 현재 코디네이터로 destination 함수에서 라우팅이 정의되어야함
    /// 단일 코디네이터에서 여러 flow 를 정의 및 관리하는 경우 사용
    func present(route: Route) {
        topNavigationController.presentedRoute = route

        let navigationController = NavigationController<Route> { [weak self] navigationController in
            self?.dismissNavigationController(navigationController)
        }

        self.navigationControllers.append(navigationController)
    }

    /// Presentation flow 제거
    func dismissPresentation() {
        guard self.navigationControllers.count > 1 else { return }
        self.navigationControllers.removeLast()
        topNavigationController.presentedRoute = nil
    }

    /// Presentation flow(sheet, fullScreenCover) 가 사라질 때 해당 네이게이션 상태를 제거
    private func dismissNavigationController(_ navigationController: NavigationController<Route>) {
        guard let index = self.navigationControllers.firstIndex(where: { $0 === navigationController }) else {
            return
        }

        let removalCountFromLast = self.navigationControllers.count - index - 1;
        self.navigationControllers.removeLast(removalCountFromLast)
    }

    /// 가장 마지막에 추가된 컨트롤러 객체
    var topNavigationController: NavigationController<Route> {
        guard let navigationController = self.navigationControllers.last else {
            fatalError("Top navigation controller not found")
        }

        return navigationController
    }

    /// 가장 처음 추가된 컨트롤러 객체
    var rootNavigationController: NavigationController<Route> {
        guard let navigationController = navigationControllers.first else {
            fatalError("Root navigation controller not found")
        }

        return navigationController
    }
}
