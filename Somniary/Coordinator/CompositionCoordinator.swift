//
//  ComposableCoordinator.swift
//  Somniary
//
//  Created by 송태환 on 9/18/25.
//

import Foundation

protocol CompositionCoordinator: Coordinator {
    
    associatedtype Key: Hashable

    var childCoordinators: [Key: any Coordinator] { get set }
}

extension CompositionCoordinator {

    func didFinish(childCoordinator: any Coordinator) {
        if let key = childCoordinators.first(where: { $0.value === childCoordinator })?.key {
            childCoordinators.removeValue(forKey: key)
        }
    }
}
