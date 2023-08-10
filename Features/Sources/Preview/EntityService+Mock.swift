//
//  EntityService+Mock.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

//#if DEBUG || PREVIEW
import Combine
import Domain
import Foundation

public enum EntityMock {
    public static let mainLight = Domain.LightEntity(id: "light.main_light", name: "Main Light", state: .on)
    public static let ledDeskLight = Domain.LightEntity(id: "light.led_desk", name: "Led Desk", state: .off)
    public static let ledCeilingLight = Domain.LightEntity(id: "light.led_ceiling", name: "Led Ceiling", state: .on)
    public static let climate = Domain.ClimateEntity(id: "climate.air_conditioner", name: "Air Conditioner", state: .cool)
    public static let coffeeMachine = Domain.SwitchEntity(id: "switch.coffee_machine", name: "Coffee Machine", state: .off)
    public static let fan = Domain.FanEntity(id: "fan.bedroom_fan", name: "Bedroom's Fan", percentageStep: 0.2, percentage: 0.2, state: .on)

    public static var all: [any Entity] = [mainLight, ledDeskLight, ledCeilingLight, climate, coffeeMachine, fan]
    public static var allDict: [String : any Entity] = all.reduce(into: [String : any Entity](), { $0[$1.id] = $1 })
}

public class EntityServiceMock: Domain.EntityService {

    public var entityStateChanged: PassthroughSubject<any Domain.Entity, Never> = .init()
    public var hiddenEntityIDs: CurrentValueSubject<Set<String>, Never> = .init(["light_led_desk"])
    public var entities: CurrentValueSubject<[String : any Domain.Entity], Never> = .init(EntityMock.allDict)
    public var domains: CurrentValueSubject<[Domain.EntityDomain], Never> = .init(Domain.EntityDomain.allCases)

    public init() {}

    public func startTracking() async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(2))
        }
    }

    public func persist() async throws {}
    public func update(entityID: String, entity: any Entity) async throws {}
    public func update(hiddenEntityIDs: Set<String>) {}
    public func execute(service: EntityActionService, entityID: String) async throws {}
}
//#endif
