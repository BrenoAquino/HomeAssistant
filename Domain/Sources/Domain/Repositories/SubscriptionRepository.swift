//
//  SubscriptionRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public protocol SubscriptionRepository {
    /// Interface to publish all state changed messages
    var stateChangedEvent: AnyPublisher<StateChangedEvent, Error> { get }
    /// Unsubscribe to stop to receive notifications regarding an operation
    func unsubscribe(operationID: Int) async throws
    /// Subscribe to receive notifications regarding an operation
    func subscribeToEvents(eventType: EventType) async throws -> Int
}
