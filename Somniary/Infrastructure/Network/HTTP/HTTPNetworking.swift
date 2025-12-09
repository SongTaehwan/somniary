//
//  HTTPNetworking.swift
//  Somniary
//
//  Created by 송태환 on 9/30/25.
//

import Foundation

protocol HTTPNetworking<Target> {
    associatedtype Target: Endpoint

    func request(_ endpoint: Target) async -> Result<HTTPResponse, TransportError>
}
