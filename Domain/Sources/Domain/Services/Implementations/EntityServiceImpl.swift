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

    public private(set) var entitiesHandler: Entities = .init()
    private var cancellable: Set<AnyCancellable> = []
    private var stateChangeSubscription: Int?

    // MARK: Publishers

    public private(set) var entities: CurrentValueSubject<Entities, Never> = .init(.init())
    public private(set) var domains: CurrentValueSubject<[EntityDomain], Never> = .init(EntityDomain.allCases)

    // MARK: Repositories

    private let fetcherRepository: FetcherRepository
    private let commandRepository: CommandRepository
    private let subscriptionRepository: SubscriptionRepository

    // MARK: Init

    public init(
        fetcherRepository: FetcherRepository,
        commandRepository: CommandRepository,
        subscriptionRepository: SubscriptionRepository
    ) {
        self.fetcherRepository = fetcherRepository
        self.commandRepository = commandRepository
        self.subscriptionRepository = subscriptionRepository
    }
}

// MARK: - Private Methods

extension EntityServiceImpl {

    private func insertEntity(_ entity: Entity) {
        let id = entity.id
        switch entity {
        case let light as LightEntity:
            entitiesHandler.lights[id] = light
        case let `switch` as SwitchEntity:
            entitiesHandler.switches[id] = `switch`
        case let fan as FanEntity:
            entitiesHandler.fans[id] = fan
        case let climate as ClimateEntity:
            entitiesHandler.climates[id] = climate
        default:
            break
        }
        entities.send(entitiesHandler)
    }

    private func setupSubscription() {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                guard let self else { return }
                self.entitiesHandler.all[stateChanged.id]?.state = stateChanged.newState
                self.entities.send(self.entitiesHandler)
            }
            .store(in: &cancellable)
    }
}

// MARK: - EntityService

extension EntityServiceImpl: EntityService {

    public func trackEntities() async throws {
        try await fetcherRepository.fetchStates().forEach { [self] in insertEntity($0) }
        entitiesHandler.updateAllEntities()
        stateChangeSubscription = try await subscriptionRepository.subscribeToEvents(eventType: .stateChanged)
        setupSubscription()
    }

    public func updateEntity(_ entityID: String, service: EntityActionService) async throws {
        try await commandRepository.callService(entityID: entityID, service: service)
    }
}
