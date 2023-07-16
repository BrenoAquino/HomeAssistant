//
//  WebSocketProvider.swift
//  
//
//  Created by Breno Aquino on 13/07/23.
//

import Foundation
import Combine

public typealias WebSocketMessage = (header: WebSocketMessageHeader, data: Data)

public enum WebSocketProviderError: Error {
    case unknown
}

public protocol WebSocketProvider {
    /// Publisher to post all new messages received
    var messageReceived: AnyPublisher<WebSocketMessage, Never> { get }
    /// Send a message without a data response
    func send<Message: Encodable>(message: Message) async throws -> Int
    /// Send a message and get an response
    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> (id: Int, response: Response)
}
