//
//  CommandRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Common
import Foundation

public protocol CommandRepository {
    /// Request to run a service for a specific entity
    func callService(entityID: String, service: EntityActionService) async throws
}
