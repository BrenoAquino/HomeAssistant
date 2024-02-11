//
//  EntityLocalDataSource.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation

public protocol EntityLocalDataSource {
    /// Retrieves all hidden entities IDs, throwing an error if the operation fails.
    func hiddenEntityIDs() async throws -> [String]
    /// Saves all hidden entities IDs, throwing an error if the operation fails.
    func save(hiddenEntityIDs: [String]) async throws
}
