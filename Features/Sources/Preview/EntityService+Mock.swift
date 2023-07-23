//
//  EntityService+Mock.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

#if DEBUG
import Combine
import Domain
import Foundation

public enum EntityMock {
    public static let mainLight = Domain.LightEntity(id: "light.main_light", name: "Main Light", state: .on)
    public static let ledDeskLight = Domain.LightEntity(id: "light.led_desk", name: "Led Desk", state: .off)
    public static let ledCeilingLight = Domain.LightEntity(id: "light.led_ceiling", name: "Led Ceiling", state: .on)
    public static let climate = Domain.ClimateEntity(id: "climate.air_conditioner", name: "Air Conditioner", state: .on)
    public static let coffeeMachine = Domain.SwitchEntity(id: "switch.coffee_machine", name: "Coffee Machine", state: .off)
    public static let fan = Domain.FanEntity(id: "fan.bedroom_fan", name: "Bedroom's Fan", percentageStep: 20, percentage: 20, state: .on)

    public static var all: [any Entity] = [mainLight, ledDeskLight, ledCeilingLight, climate, coffeeMachine, fan]
}

public class EntityServiceMock: Domain.EntityService {

    @Published public private(set) var domains = Domain.EntityDomain.allCases
    @Published public var entities = EntityMock.all.reduce(into: [String : any Entity](), { $0[$1.id] = $1 })

    public init() {}

    public func trackEntities() async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(2))
        }
    }

    public func update(entityID: String, entity: any Entity) async throws {
        entities[entityID] = entity
    }

    public func execute(service: EntityActionService, entityID: String) async throws {

    }
}
#endif
