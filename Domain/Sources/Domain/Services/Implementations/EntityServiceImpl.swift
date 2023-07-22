//
//  EntityServiceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Combine
import Foundation

public enum EntityServiceImplError: Error {
    case missingElement
}

public class EntityServiceImpl {

    // MARK: Variables

    private(set) var allEntities: [String : any Entity] = [:]
    private var cancellable: Set<AnyCancellable> = []
    private var stateChangeSubscription: Int?

    // MARK: Publishers

    public private(set) var entities: CurrentValueSubject<[String : any Entity], Never> = .init([:])
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

    private func insertEntity(_ entity: any Entity) {
        let id = entity.id
        switch entity {
        case let light as LightEntity:
            allEntities[id] = light
        case let `switch` as SwitchEntity:
            allEntities[id] = `switch`
        case let fan as FanEntity:
            allEntities[id] = fan
        case let climate as ClimateEntity:
            allEntities[id] = climate
        default:
            break
        }
        entities.send(allEntities)
    }

    private func setupSubscription() {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                guard let self else { return }
                self.allEntities[stateChanged.id]?.state = stateChanged.newState
                self.entities.send(self.allEntities)
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

    public func update(entityID: String, entity: any Entity) async throws {
        guard allEntities[entityID] != nil else { throw EntityServiceImplError.missingElement }
        allEntities[entityID] = entity
    }

    public func execute(service: EntityActionService, entityID: String) async throws {
        try await commandRepository.callService(entityID: entityID, service: service)
    }
}
