//
//  ConfigServiceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class ConfigServiceImpl {
    private let serverRepository: ServerRepository

    public init(serverRepository: ServerRepository) {
        self.serverRepository = serverRepository
    }
}

// MARK: - ConfigService

extension ConfigServiceImpl: ConfigService {
    public func config() async throws -> ServerConfig {
        try await serverRepository.fetchConfig()
    }
}
