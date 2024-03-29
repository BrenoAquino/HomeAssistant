//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public enum EntityServiceError: Error {
    
    case missingElement
}

public protocol EntityService {

    var hiddenEntityIDs: CurrentValueSubject<Set<String>, Never> { get }
    var entities: CurrentValueSubject<[String : any Entity], Never> { get }
    var domains: CurrentValueSubject<[EntityDomain], Never> { get }

    func startTracking() async throws

    func update(entityID: String, entity: any Entity) async throws
    func update(hiddenEntityIDs: Set<String>)

    func execute(service: EntityActionService, entityID: String) async throws
}
