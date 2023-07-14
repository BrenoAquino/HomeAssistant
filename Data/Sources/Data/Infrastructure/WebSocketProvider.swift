//
//  WebSocketProvider.swift
//  
//
//  Created by Breno Aquino on 13/07/23.
//

import Foundation
import Combine

public typealias WebSocketMessageWrapper = (header: WebSocketMessageHeader, data: Data)

public protocol WebSocketProvider {
    /// Publisher to post all new messages received
    var messageReceived: AnyPublisher<WebSocketMessageWrapper, Never> { get }
    /// Send a message and try to receive an response
    func send<Message: Encodable & WebSocketMessage, Response: Decodable>(
        message: Message
    ) async throws -> ResultWebSocketMessage<Response>
}
