//
//  WebSocketProvider.swift
//  
//
//  Created by Breno Aquino on 13/07/23.
//

import Foundation
import Combine

/// Pattern for WebSocket message
public typealias WebSocketMessage = (header: WebSocketMessageHeader, data: Data)

public enum WebSocketProviderError: Error {
    /// An error that could not be handled
    case unknown(error: Error)
}

public enum WebSocketProviderState {
    /// State when the connection is on
    case online
    /// State when the connection is off
    case offline
}

public protocol WebSocketProvider {
    /// An interface to check any new state for the WebSocket connection
    var connectionStateChanged: AnyPublisher<WebSocketProviderState, Never> { get }
    /// An interface to check all received messages
    var messageReceived: AnyPublisher<WebSocketMessage, Never> { get }
    /// Sends a message to WebSocket and get the operation ID regarding the message
    @discardableResult func send<Message: Encodable>(message: Message) async throws -> Int
    /// Sends a message to WebSocket and wait for a response
    func send<Message: Encodable, Response: Decodable>(message: Message) async throws -> (id: Int, response: Response)
}
