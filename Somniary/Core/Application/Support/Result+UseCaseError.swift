//
//  Result+UseCaseError.swift
//  Somniary
//
//  Created by 송태환 on 1/5/26.
//

extension Result {
    func mapPortFailureToUseCaseError<
        Contract: Error & Equatable,
        Boundary: Error & Equatable
    >(
        contract: Contract.Type,
        classifyAsContract: @escaping (Boundary) -> Contract?
    ) -> Result<Success, UseCaseError<Contract, Boundary>>
    where Failure == PortFailure<Boundary> {
        mapError { portFailure -> UseCaseError<Contract, Boundary> in
            switch portFailure {
            case .system(let error):
                return .system(error)
            case .boundary(let error):
                return .from(boundaryError: error, classify: classifyAsContract)
            }
        }
    }
}
