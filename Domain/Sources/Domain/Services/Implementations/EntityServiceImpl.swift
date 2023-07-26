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

    private var cachedEntities: [String : any Entity] = [:]
    private var cachedHiddenEntityIDs: Set<String> = []

    // MARK: Subjects

    public private(set) var entityStateChanged: PassthroughSubject<any Entity, Never> = .init()
    public private(set) var hiddenEntityIDs: CurrentValueSubject<Set<String>, Never> = .init([])
    public private(set) var entities: CurrentValueSubject<[String : any Entity], Never> = .init([:])
    public private(set) var domains: CurrentValueSubject<[EntityDomain], Never> = .init(EntityDomain.allCases)

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
            cachedEntities[id] = light
        case let climate as ClimateEntity:
            cachedEntities[id] = climate
        case let `switch` as SwitchEntity:
            cachedEntities[id] = `switch`
        case let fan as FanEntity:
            cachedEntities[id] = fan
        default:
            break
        }
        entities.send(cachedEntities)
    }

    private func setupSubscription() {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                guard let entity = self?.cachedEntities[stateChanged.id] else { return }
                self?.cachedEntities[stateChanged.id] = entity.stateUpdated(stateChanged.newState) as any Entity
                guard let entityUpdated = self?.cachedEntities[stateChanged.id] else { return }
                self?.entityStateChanged.send(entityUpdated)
            }
            .store(in: &cancellable)
    }
}

// MARK: - EntityService

extension EntityServiceImpl: EntityService {

    public func persist() async throws {
        try await entityRepository.save(hiddenEntityIDs: cachedHiddenEntityIDs)
        Logger.log(level: .info, "Saved \(cachedHiddenEntityIDs.count) hidden entity IDs")
    }

    public func startTracking() async throws {
        try await entityRepository.fetchStates().forEach { [self] in insertEntity($0) }
        stateChangeSubscriptionID = try await subscriptionRepository.subscribeToEvents(eventType: .stateChanged)

        let fetchedHiddenEntities = try? await entityRepository.fetchHiddenEntityIDs()
        cachedHiddenEntityIDs = fetchedHiddenEntities ?? []
        hiddenEntityIDs.send(cachedHiddenEntityIDs)

        setupSubscription()
    }

    public func update(hiddenEntityIDs: Set<String>) {
        cachedHiddenEntityIDs = hiddenEntityIDs
        self.hiddenEntityIDs.send(cachedHiddenEntityIDs)
    }

    public func update(entityID: String, entity: any Entity) async throws {
        guard cachedEntities[entityID] != nil else {
            throw EntityServiceError.missingElement
        }
        cachedEntities[entityID] = entity
        entities.send(cachedEntities)
    }

    public func execute(service: EntityActionService, entityID: String) async throws {
        try await commandRepository.callService(entityID: entityID, service: service)
    }
}
