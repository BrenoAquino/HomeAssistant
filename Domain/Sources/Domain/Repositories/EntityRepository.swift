//
//  EntityRepository.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation

public protocol EntityRepository {

    func save(hiddenEntityIDs: Set<String>) async throws

    func fetchHiddenEntityIDs() async throws -> Set<String>
    func fetchStates() async throws -> [any Entity]
}
