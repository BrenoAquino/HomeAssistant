//
//  SubscriptionRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public protocol SubscriptionRemoteDataSource {
    /// All events would be published here
    var event: AnyPublisher<Data, Never> { get }
    /// Send an unsubscribe message to stop receive messages regarding the request
    func unsubscribe(operationID: Int) async throws
    /// Send a subscribe message to start to track a specific kind of events
    func subscribeToEvents(eventType: String) async throws -> Int
}
