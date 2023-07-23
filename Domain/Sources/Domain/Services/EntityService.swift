//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public protocol EntityService {

    var entities: CurrentValueSubject<[String : any Entity], Never> { get }
    var domains: CurrentValueSubject<[EntityDomain], Never> { get }

    func trackEntities() async throws
    func update(entityID: String, entity: any Entity) async throws
    func execute(service: EntityActionService, entityID: String) async throws
}
