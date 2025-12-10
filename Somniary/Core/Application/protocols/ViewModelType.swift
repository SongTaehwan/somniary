//
//  ViewModelType.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

@MainActor
protocol ViewModelType: ObservableObject {

    associatedtype State
    associatedtype Intent

    var state: State { get set }

    func send(_ intent: Intent)
}
