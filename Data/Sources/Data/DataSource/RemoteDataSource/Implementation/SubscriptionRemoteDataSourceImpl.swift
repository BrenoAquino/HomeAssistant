//
//  SubscriptionRemoteDataSourceImpl.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Combine
import Common
import Foundation

public class SubscriptionRemoteDataSourceImpl {
    private let webSocketProvider: WebSocketProvider

    public init(webSocketProvider: WebSocketProvider) {
        self.webSocketProvider = webSocketProvider
    }
}

// MARK: - SubscriptionRemoteDataSource

extension SubscriptionRemoteDataSourceImpl: SubscriptionRemoteDataSource {
    public var event: AnyPublisher<Data, Never> {
        webSocketProvider
            .messageReceived
            .filter { $0.header.type == .event }
            .map { $0.data }
            .eraseToAnyPublisher()
    }

    public func unsubscribe(operationID: Int) async throws {
        try await webSocketProvider.send(message: UnsubscribeMessage(subscription: operationID))
    }

    public func subscribeToEvents(eventType: String) async throws -> Int {
        try await webSocketProvider.send(message: SubscribeToEventMessage(eventType: eventType))
    }
}
