//
//  UseCase.swift
//  Somniary
//
//  Created by 송태환 on 12/22/25.
//

import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output

    func execute() async throws -> Output
    func execute(_ input: Input) async throws -> Output
}

extension UseCase {
    func execute() async throws  -> Output {
        fatalError("Not implemented")
    }

    func execute(_ input: Input) async throws -> Output {
        fatalError("Not implemented")
    }
}
