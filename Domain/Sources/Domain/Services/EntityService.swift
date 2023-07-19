//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public class Entities {

    public var all: [String : Entity] = [:]
    public var lights: [String : LightEntity] = [:]
    public var switches: [String : SwitchEntity] = [:]
    public var fans: [String : FanEntity] = [:]
    public var climates: [String : ClimateEntity] = [:]

    public init() {}

    public func updateAllEntities() {
        all = [:]
        lights.values.forEach { all[$0.id] = $0 }
        switches.values.forEach { all[$0.id] = $0 }
        fans.values.forEach { all[$0.id] = $0 }
        climates.values.forEach { all[$0.id] = $0 }
    }
}

public protocol EntityService {

    var entities: CurrentValueSubject<Entities, Never> { get }
    var domains: CurrentValueSubject<[EntityDomain], Never> { get }

    func trackEntities() async throws
    func updateEntity(_ entityID: String, service: EntityActionService) async throws
}
