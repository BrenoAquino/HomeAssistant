//
//  SubscriptionRepositoryImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Combine
import Domain
import Foundation

public class SubscriptionRepositoryImpl {

    private let subscriptionRemoteDataSource: SubscriptionRemoteDataSource

    public init(subscriptionRemoteDataSource: SubscriptionRemoteDataSource) {
        self.subscriptionRemoteDataSource = subscriptionRemoteDataSource
    }
}

// MARK: - SubscriptionRepository

extension SubscriptionRepositoryImpl: SubscriptionRepository {
    public var stateChangedEvent: AnyPublisher<Domain.StateChangedEvent, Error> {
        subscriptionRemoteDataSource
            .event
            .decode(type: StateChangedEvent.self, decoder: JSONDecoder(), atKeyPath: "event")
            .filter { $0.eventType == Domain.EventType.stateChanged.toData() }
            .compactMap { try? $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func unsubscribe(operationID: Int) async throws {
        try await subscriptionRemoteDataSource.unsubscribe(operationID: operationID)
    }

    public func subscribeToEvents(eventType: Domain.EventType) async throws -> Int {
        try await subscriptionRemoteDataSource.subscribeToEvents(eventType: eventType.toData())
    }
}
