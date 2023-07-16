//
//  FetcherRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol FetcherRemoteDataSource {

    func fetchConfig() async throws -> ServerConfig
    func fetchStates() async throws -> [EntityState]
}
