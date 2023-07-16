//
//  StateRemoteDataSourceImplTests.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Combine
import XCTest
@testable import Data

final class StateRemoteDataSourceImplTests: XCTestCase {

    var webSocketMock: WebSocketProviderMock!
    var subject: StateRemoteDataSourceImpl!

    override func setUp() {
        super.setUp()

        webSocketMock = WebSocketProviderMock()
        subject = StateRemoteDataSourceImpl(webSocketProvider: webSocketMock)
    }

    func testFetchingStatesMapping() throws {
        // Given
        // When
        // Then
    }
}

// MARK: - WebSocketProviderMock

class WebSocketProviderMock {

    var topic: PassthroughSubject<WebSocketMessage, Never> = .init()
}

extension WebSocketProviderMock: WebSocketProvider {

    var messageReceived: AnyPublisher<WebSocketMessage, Never> {
        topic.eraseToAnyPublisher()
    }

    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> ResultWebSocketMessage<Response> {
        throw NSError()
    }
}
