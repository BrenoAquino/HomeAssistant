//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public enum EntityServiceError: Error {
    /// When the service tries to access an entity that does not exist
    case missingEntity
}

public protocol EntityService {
    /// List of all hidden entities
    var hiddenEntityIDs: Set<String> { get }
    /// An interface to be notified when the list of hidden entities changes
    var hiddenEntityIDsPublisher: AnyPublisher<Set<String>, Never> { get }
    /// List of all entities
    var entities: [String: any Entity] { get }
    /// An interface to be notified when any entity changes
    var entitiesPublisher: AnyPublisher<[String : any Entity], Never> { get }
    /// List of all available domains
    var domains: [EntityDomain] { get }
    /// Load all entities
    func load() async throws
    /// Start to track entities states
    func startTracking() async throws
    /// Update entity
    func update(entityID: String, entity: any Entity) async throws
    /// Update hidden entities list
    func update(hiddenEntityIDs: Set<String>)
    /// Execute a command on a specific entity
    func execute(service: EntityActionService, entityID: String) async throws
}
