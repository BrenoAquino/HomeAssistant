//
//  EntityRepository.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation

public protocol EntityRepository {
    /// Save entity IDs to be hidden
    func save(hiddenEntityIDs: Set<String>) async throws
    /// Retrieve all hidden entity IDs
    func fetchHiddenEntityIDs() async throws -> Set<String>
    /// Retrieve all entities states
    func fetchStates() async throws -> [any Entity]
}
