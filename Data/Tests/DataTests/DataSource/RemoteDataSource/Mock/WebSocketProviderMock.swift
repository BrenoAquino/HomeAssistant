//
//  File.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation
import Common
import Combine
@testable import Data

class WebSocketProviderMock {

    var messageSent: Any?
    var sendReturn: (id: Int, response: Any)?
    var topic: PassthroughSubject<WebSocketMessage, Never> = .init()
}

extension WebSocketProviderMock: WebSocketProvider {

    var messageReceived: AnyPublisher<WebSocketMessage, Never> {
        topic.eraseToAnyPublisher()
    }

    @discardableResult
    func send<Message: Encodable>(message: Message) async throws -> Int {
        messageSent = message
        return sendReturn?.id ?? .zero
    }

    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> (id: Int, response: Response) {
        messageSent = message
        if let sendReturn, let response = sendReturn.response as? Response {
            return (sendReturn.id, response)
        } else {
            throw NSError()
        }
    }
}
