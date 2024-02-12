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
    public private(set) var domains: [EntityDomain] = .init(EntityDomain.allCases)

    // MARK: Subjects

    @Published public private(set) var hiddenEntityIDs: Set<String> = []
    @Published public private(set) var entities: [String: any Entity] = [:]

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
        case let climate as ClimateEntity:
            entities[id] = climate
        case let `switch` as SwitchEntity:
            entities[id] = `switch`
        case let fan as FanEntity:
            entities[id] = fan
        default:
            break
        }
    }
    
    private func persist() async throws {
        try await entityRepository.save(hiddenEntityIDs: hiddenEntityIDs)
    }
}

// MARK: - EntityService

extension EntityServiceImpl: EntityService {
    public var hiddenEntityIDsPublisher: AnyPublisher<Set<String>, Never> {
        $hiddenEntityIDs.eraseToAnyPublisher()
    }
    
    public var entitiesPublisher: AnyPublisher<[String : any Entity], Never> {
        $entities.eraseToAnyPublisher()
    }

    public func load() async throws {
        try await entityRepository.fetchStates().forEach { [self] in insertEntity($0) }
        stateChangeSubscriptionID = try await subscriptionRepository.subscribeToEvents(eventType: .stateChanged)
        hiddenEntityIDs = (try? await entityRepository.fetchHiddenEntityIDs()) ?? []
    }

    public func startTracking() async throws {
        subscriptionRepository
            .stateChangedEvent
            .sink { _ in } receiveValue: { [weak self] stateChanged in
                guard let entity = self?.entities[stateChanged.id] else { return }
                self?.entities[stateChanged.id] = entity.stateUpdated(stateChanged.newState) as any Entity
            }
            .store(in: &cancellable)
    }

    public func update(hiddenEntityIDs: Set<String>) {
        self.hiddenEntityIDs = hiddenEntityIDs
        Task { try? await persist() }
    }

    public func update(entityID: String, entity: any Entity) async throws {
        guard entities[entityID] != nil else {
            throw EntityServiceError.missingEntity
        }
        entities[entityID] = entity
    }

    public func execute(service: EntityActionService, entityID: String) async throws {
        try await commandRepository.callService(entityID: entityID, service: service)
    }
}
