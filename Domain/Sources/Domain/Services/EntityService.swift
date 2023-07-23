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

public protocol EntityService: ObservableObject {

    var hiddenEntities: Set<String> { get set }
    var entities: [String : any Entity] { get set }
    var domains: [EntityDomain] { get }

    func persistHiddenEntities() async throws

    func trackEntities() async throws
    func update(entityID: String, entity: any Entity) async throws
    func execute(service: EntityActionService, entityID: String) async throws
}
