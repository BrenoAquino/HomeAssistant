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

public enum WebSocketProviderState {

    case online
    case offline
}

public protocol WebSocketProvider {

    var stateChanged: AnyPublisher<WebSocketProviderState, Never> { get }
    var messageReceived: AnyPublisher<WebSocketMessage, Never> { get }

    @discardableResult
    func send<Message: Encodable>(
        message: Message
    ) async throws -> Int

    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> (id: Int, response: Response)
}
