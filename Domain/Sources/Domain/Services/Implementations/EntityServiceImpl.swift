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

    private var allEntities: [String : Entity] = [:]
    public private(set) var entities: [EntityDomain: Set<Entity>] = [:] {
        didSet {
            allEntities = [:]
            for entitiesByDomain in entities {
                entitiesByDomain.value.forEach { allEntities[$0.id] = $0 }
            }
        }
    }

    private var cancellable: Set<AnyCancellable> = []
    private var stateChangeSubscription: Int?

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
        if entities[entity.domain] != nil {
            entities[entity.domain]?.insert(entity)
        } else {
            entities[entity.domain] = [entity]
        }
    }

    private func setupSubscription() {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                self?.allEntities[stateChanged.id]?.state = stateChanged.newState
            }
            .store(in: &cancellable)
    }
}

// MARK: - EntityService

extension EntityServiceImpl: EntityService {

    public func trackEntities() async throws {
        try await fetcherRepository.fetchStates().forEach { [self] in insertEntity($0) }
        stateChangeSubscription = try await subscriptionRepository.subscribeToEvents(eventType: .stateChanged)
        setupSubscription()
    }

    public func updateEntity(_ entityID: String, service: EntityActionService) async throws {
        
    }
}
