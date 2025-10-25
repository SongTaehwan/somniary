//
//  SomniaryNetworking.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation
import Combine

protocol SomniaryNetworking<Target> {
    associatedtype Target: SomniaryEndpoint

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError>
}
