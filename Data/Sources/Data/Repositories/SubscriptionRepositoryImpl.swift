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

    private let subscriptionRemoteDateSource: SubscriptionRemoteDataSource

    public init(subscriptionRemoteDateSource: SubscriptionRemoteDataSource) {
        self.subscriptionRemoteDateSource = subscriptionRemoteDateSource
    }
}

// MARK: - SubscriptionRepository

extension SubscriptionRepositoryImpl: SubscriptionRepository {

    public var stateChangedEvent: AnyPublisher<Domain.StateChangedEvent, Error> {
        subscriptionRemoteDateSource
            .event
            .decode(type: StateChangedEvent.self, decoder: JSONDecoder())
            .tryMap { try $0.toDomain() }
            .eraseToAnyPublisher()
    }

    public func unsubscribe(operationID: Int) async throws {
        try await subscriptionRemoteDateSource.unsubscribe(operationID: operationID)
    }

    public func subscribeToEvents(eventType: EventType) async throws -> Int {
        try await subscriptionRemoteDateSource.subscribeToEvents(eventType: eventType.string)
    }
}
