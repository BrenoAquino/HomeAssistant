//
//  SubscriptionRemoteDataSourceImplTests.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Combine
import XCTest
@testable import Data

final class SubscriptionRemoteDataSourceImplTests: XCTestCase {

    var webSocketMock: WebSocketProviderMock!
    var subject: SubscriptionRemoteDataSourceImpl!

    override func setUp() {
        super.setUp()

        webSocketMock = WebSocketProviderMock()
        subject = SubscriptionRemoteDataSourceImpl(webSocketProvider: webSocketMock)
    }

    func testSubscribeToEvents() async throws {
        // When
        let _ = try await subject.subscribeToEvents(eventType: "event type")

        // Then
        guard let message = webSocketMock.messageSent as? SubscribeToEventMessage else {
            XCTFail("message must be an FireEventMessage<EmptyCodable>")
            return
        }
        XCTAssertEqual(message.eventType, "event type")
    }

    func testUnsubscribe() async throws {
        // When
        try await subject.unsubscribe(operationID: .zero)

        // Then
        guard let message = webSocketMock.messageSent as? UnsubscribeMessage else {
            XCTFail("message must be an FireEventMessage<EmptyCodable>")
            return
        }
        XCTAssertEqual(message.subscription, .zero)
    }
}
