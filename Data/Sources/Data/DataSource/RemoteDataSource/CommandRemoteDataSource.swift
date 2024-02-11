//
//  CommandRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol CommandRemoteDataSource {
    /// Send a message to run a service
    func callService<T: Encodable>(domain: String, service: String, entityID: String?, serviceData: T?) async throws
}
