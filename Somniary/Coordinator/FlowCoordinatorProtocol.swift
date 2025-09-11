//
//  FlowCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/11/25.
//

import SwiftUI

/// Flow 정의 및 라우팅 처리 담당 Coordinator
protocol FlowCoordinator: Coordinator {

    associatedtype Route: Routable
    associatedtype Destination: View

    /// sheet, fullScreenCover 로 인해 Nested navigation stack 구조를 가질 수 있기 때문에 배열로 상태 객체를 저장
    var navigationControllers: [NavigationController<Route>] { get set }

    /// 자식 코디네이터는 독립된 Flow 의 관리 목적으로 사용됨
    /// 코디네이터별 관심사 분리
    var childCoordinator: (any Coordinator)? { get set }

    /// 라우팅 분기점
    @MainActor @ViewBuilder func destination(for route: Route) -> Destination
}

// MARK: 해당 코디네이터 관련
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
    /// 다음 화면 추가
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

    /// 현재 보이는 Presentation flow 제거
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

// MARK: 자식 코디네이터 관련
extension FlowCoordinator {

    /// 자식 코디네이터 플로우 노출
    /// 객체 관점에서는 addChild 와 동일
    func present(child: any Coordinator) {
        child.finishDelegate = self
        self.childCoordinator = child
    }

    /// 자식 코디네이터 플로우 종료
    /// 객체 관점에서는 removeChild 와 동일
    private func dismissChild() {
        self.childCoordinator = nil
    }

    /// CoordinatorFinishDelegate 메소드 구현체
    func didFinish(childCoordinator: any Coordinator) {
        self.dismissChild()
    }

    /// 여러 Presentation 을 한꺼번에 닫음
    func dismissToRoot() {
        // 자식 코디네이터 제거 시 shouldPresentChild 에 의해 Presentation 제거됨
        self.childCoordinator?.finish()
        // root 컨트롤러를 제외한 나머지 제거
        guard self.navigationControllers.count > 1 else { return }
        self.navigationControllers.removeLast(self.navigationControllers.count - 1)
        // root 컨트롤러의 presentation 제거 시
        rootNavigationController.presentedRoute = nil
    }

    /// 자식 코디네이터를 sheet, fullScreenCover 를 통해 노출시키는데 사용됨.
    /// childCoordinator 값이 변경될 때 마다 호출됨
    func shouldPresentChild(from navigationController: NavigationController<Route>) -> Binding<Bool> {
        return Binding<Bool> { [weak self] in
            guard let self else { return false }
            return self.childCoordinator != nil && self.isTopNavigationController(navigationController)
        } set: { [weak self] newValue in
            guard let self, !newValue else { return }
            self.dismissChild()
        }
    }

    func isTopNavigationController(_ navigationController: NavigationController<Route>) -> Bool {
        return navigationControllers.last === navigationController
    }
}
