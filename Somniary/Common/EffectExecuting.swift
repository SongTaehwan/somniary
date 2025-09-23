//
//  EffectExecuting.swift
//  Somniary
//
//  Created by 송태환 on 9/23/25.
//

import Foundation

protocol EffectExecuting<Plan, Intent>: AnyObject {
    associatedtype Plan
    associatedtype Intent

    func perform(_ plan: Plan, send: @escaping (Intent) -> Void)
}
