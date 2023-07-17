//
//  ConfigServiceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class ConfigServiceImpl {

    private let fetcherRepository: FetcherRepository

    public init(fetcherRepository: FetcherRepository) {
        self.fetcherRepository = fetcherRepository
    }
}

// MARK: - ConfigService

extension ConfigServiceImpl: ConfigService {

    public func config() async throws -> ServerConfig {
        try await fetcherRepository.fetchConfig()
    }
}
