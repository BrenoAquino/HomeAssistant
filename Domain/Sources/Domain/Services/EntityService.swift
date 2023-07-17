//
//  EntityService.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public class Entities {

    public var lights: [String : LightEntity] = [:] {
        didSet { updateAllEntities() }
    }
    public var switches: [String : SwitchEntity] = [:] {
        didSet { updateAllEntities() }
    }
    public var fans: [String : FanEntity] = [:] {
        didSet { updateAllEntities() }
    }
    public var climates: [String : ClimateEntity] = [:] {
        didSet { updateAllEntities() }
    }

    public var all: [String : Entity] = [:]

    private func updateAllEntities() {
        all = [:]
        lights.values.forEach { all[$0.id] = $0 }
        switches.values.forEach { all[$0.id] = $0 }
        fans.values.forEach { all[$0.id] = $0 }
        climates.values.forEach { all[$0.id] = $0 }
    }
}

public protocol EntityService {

    var entities: Entities { get }

    func trackEntities() async throws
    func updateEntity(_ entityID: String, service: EntityActionService) async throws
}
