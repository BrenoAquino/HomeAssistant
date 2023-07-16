//
//  StateRemoteDataSourceImplTests.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Common
import Combine
import XCTest
@testable import Data

final class CommandRemoteDataSourceImplTests: XCTestCase {

    var webSocketMock: WebSocketProviderMock!
    var subject: CommandRemoteDataSourceImpl!

    override func setUp() {
        super.setUp()

        webSocketMock = WebSocketProviderMock()
        subject = CommandRemoteDataSourceImpl(webSocketProvider: webSocketMock)
    }

    func testCallServiceWithServiceData() async throws {
        // Given
        struct ServiceData: Encodable {
            let test = "test"
        }

        // When
        try await subject.callService(
            domain: "domain",
            service: "service",
            entityID: "entity",
            serviceData: ServiceData()
        )

        // Then
        guard let message = webSocketMock.messageSent as? CallServiceMessage<ServiceData> else {
            XCTFail("message must be an CallServiceMessage<ServiceData>")
            return
        }
        XCTAssertEqual(message.domain, "domain")
        XCTAssertEqual(message.service, "service")
        XCTAssertEqual(message.entityID, "entity")
        XCTAssertEqual(message.serviceData?.test, "test")

        let json = try JSONEncoder().encode(message)
        print(String(data: json, encoding: .utf8)!)
        print()
    }

    func testCallServiceWithoutServiceData() async throws {
        // When
        try await subject.callService(
            domain: "domain",
            service: "service",
            entityID: "entity"
        )

        // Then
        guard let message = webSocketMock.messageSent as? CallServiceMessage<EmptyCodable> else {
            XCTFail("message must be an CallServiceMessage<EmptyCodable>")
            return
        }
        XCTAssertEqual(message.domain, "domain")
        XCTAssertEqual(message.service, "service")
        XCTAssertEqual(message.entityID, "entity")
        XCTAssertNil(message.serviceData)
    }
}

// MARK: - WebSocketProviderMock

class WebSocketProviderMock {

    var messageSent: Any?
    var topic: PassthroughSubject<WebSocketMessage, Never> = .init()
}

extension WebSocketProviderMock: WebSocketProvider {

    var messageReceived: AnyPublisher<WebSocketMessage, Never> {
        topic.eraseToAnyPublisher()
    }

    @discardableResult
    func send<Message: Encodable>(message: Message) async throws -> Int {
        messageSent = message
        return .zero
    }

    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> (id: Int, response: Response) {
        throw NSError()
    }
}
