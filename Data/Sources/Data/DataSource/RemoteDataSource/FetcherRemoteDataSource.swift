//
//  FetcherRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol FetcherRemoteDataSource {
    /// Retrieves the server configuration
    func fetchServerConfig() async throws -> ServerConfig
    /// Retrieves all devices with their states and configurations
    func fetchEntities() async throws -> [GenericEntity]
}
