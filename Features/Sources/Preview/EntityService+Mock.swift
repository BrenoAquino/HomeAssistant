//
//  EntityService+Mock.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

#if DEBUG || PREVIEW
import Combine
import Domain
import Foundation

extension EntityServiceMock {
    private static var all: [any Entity] = [
        LightEntity.mockMainLight,
        LightEntity.mockLedDeskLight,
        LightEntity.mockLedCeilingLight,
        ClimateEntity.mock,
        SwitchEntity.mockCoffeeMachine,
        FanEntity.mock,
    ]

    private static var allDict: [String: any Entity] = all.reduce(
        into: [:],
        { $0[$1.id] = $1 }
    )
}

public class EntityServiceMock: Domain.EntityService {
    @Published public var hiddenEntityIDs: Set<String> = .init([LightEntity.mockLedDeskLight.id])
    public var hiddenEntityIDsPublisher: AnyPublisher<Set<String>, Never> {
        $hiddenEntityIDs.eraseToAnyPublisher()
    }

    @Published public var entities: [String: any Domain.Entity] = allDict
    public var entitiesPublisher: AnyPublisher<[String: any Domain.Entity], Never> {
        $entities.eraseToAnyPublisher()
    }

    public var domains: [Domain.EntityDomain] = Domain.EntityDomain.allCases

    public init() {}

    public func startTracking() async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(2))
        }
    }

    public func load() async throws {}
    public func persist() async throws {}
    public func update(entityID: String, entity: any Entity) async throws {}
    public func update(hiddenEntityIDs: Set<String>) {}
    public func execute(service: EntityActionService, entityID: String) async throws {}
}
#endif
