//
//  SubscriptionRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Combine
import Foundation

public protocol SubscriptionRemoteDataSource {

    var event: AnyPublisher<EventWebSocketMessage, Error> { get }

    func unsubscribe(operationID: Int) async throws
    func subscribeToEvents(eventType: String) async throws -> Int
}
