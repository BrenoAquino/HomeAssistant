//
//  SubscriptionRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public protocol SubscriptionRepository {

    var stateChangedEvent: AnyPublisher<StateChangedEvent, Error> { get }

    func unsubscribe(operationID: Int) async throws
    func subscribeToEvents(eventType: EventType) async throws -> Int
}
