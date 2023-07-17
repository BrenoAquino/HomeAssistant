//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol EntityService {

    var entities: [EntityDomain: Set<Entity>] { get }

    func trackEntities() async throws
    func updateEntity(_ entityID: String, service: EntityActionService) async throws
}
