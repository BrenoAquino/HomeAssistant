//
//  EntityServiceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Combine
import Foundation

public class EntityServiceImpl {

    // MARK: Variables

    private var cancellable: Set<AnyCancellable> = []
    private var stateChangeSubscriptionID: Int?

    // MARK: Publishers

    @Published public var hiddenEntities: Set<String> = []
    @Published public var entities: [String : any Entity] = [:]
    @Published public private(set) var domains: [EntityDomain] = EntityDomain.allCases

    // MARK: Repositories

    private let entityRepository: EntityRepository
    private let commandRepository: CommandRepository
    private let subscriptionRepository: SubscriptionRepository

    // MARK: Init

    public init(
        entityRepository: EntityRepository,
        commandRepository: CommandRepository,
        subscriptionRepository: SubscriptionRepository
    ) {
        self.entityRepository = entityRepository
        self.commandRepository = commandRepository
        self.subscriptionRepository = subscriptionRepository
    }
}

// MARK: - Private Methods

extension EntityServiceImpl {

    private func insertEntity(_ entity: any Entity) {
        let id = entity.id
        switch entity {
        case let light as LightEntity:
            entities[id] = light
        case let `switch` as SwitchEntity:
            entities[id] = `switch`
        case let fan as FanEntity:
            entities[id] = fan
        case let climate as ClimateEntity:
            entities[id] = climate
        default:
            break
        }
    }

    private func setupSubscription() {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                self?.entities[stateChanged.id]?.state = stateChanged.newState
            }
            .store(in: &cancellable)
    }
}

// MARK: - EntityService

extension EntityServiceImpl: EntityService {

    public func persistHiddenEntities() async throws {
        try await entityRepository.save(hiddenEntityIDs: hiddenEntities)
    }

    public func trackEntities() async throws {
        try await entityRepository.fetchStates().forEach { [self] in insertEntity($0) }
        stateChangeSubscriptionID = try await subscriptionRepository.subscribeToEvents(eventType: .stateChanged)
        hiddenEntities = try await entityRepository.fetchHiddenEntityIDs()
        setupSubscription()
    }

    public func update(entityID: String, entity: any Entity) async throws {
        guard entities[entityID] != nil else { throw EntityServiceError.missingElement }
        entities[entityID] = entity
    }

    public func execute(service: EntityActionService, entityID: String) async throws {
        try await commandRepository.callService(entityID: entityID, service: service)
    }
}
