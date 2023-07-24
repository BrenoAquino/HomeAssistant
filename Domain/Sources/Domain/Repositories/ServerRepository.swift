//
//  ServerRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol ServerRepository {

    func fetchConfig() async throws -> ServerConfig
}
