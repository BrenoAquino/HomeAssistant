//
//  EntityService+Mock.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

#if DEBUG
import Domain
import Foundation

public class EntityServiceMock: Domain.EntityService {

    public var domains: [Domain.EntityDomain] = Domain.EntityDomain.allCases
    public var entities: Domain.Entities = .init()

    public var allEntities: [Entity] {
        Array(entities.all.values)
    }

    public init() {
        let mainLight = LightEntity(id: "light.main_light", name: "Main Light", state: .on)
        let ledDesk = LightEntity(id: "light.led_desk", name: "Led Desk", state: .off)
        let ledCeiling = LightEntity(id: "light.led_ceiling", name: "Led Ceiling", state: .on)
        let climate = ClimateEntity(id: "climate.air_conditioner", name: "Air Conditioner", state: .on)
        let coffeeMachine = SwitchEntity(id: "switch.coffee_machine", name: "Coffee Machine", state: .off)
        let fan = FanEntity(id: "fan.bedroom_fan", name: "Bedroom's Fan", state: .on)
        entities.lights = [
            mainLight.id: mainLight,
            ledDesk.id: ledDesk,
            ledCeiling.id: ledCeiling,
        ]
        entities.switches = [coffeeMachine.id: coffeeMachine]
        entities.fans = [fan.id: fan]
        entities.climates = [climate.id: climate]
        entities.updateAllEntities()
    }

    public func trackEntities() async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(2))
        }
    }

    public func updateEntity(_ entityID: String, service: Domain.EntityActionService) async throws {

    }
}

#endif
