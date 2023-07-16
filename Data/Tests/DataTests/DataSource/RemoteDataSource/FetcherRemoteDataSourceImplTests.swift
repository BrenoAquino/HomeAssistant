//
//  FetcherRemoteDataSourceTests.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Combine
import XCTest
@testable import Data

final class FetcherRemoteDataSourceImplTests: XCTestCase {

    var webSocketMock: WebSocketProviderMock!
    var subject: FetcherRemoteDataSourceImpl!

    override func setUp() {
        super.setUp()

        webSocketMock = WebSocketProviderMock()
        subject = FetcherRemoteDataSourceImpl(webSocketProvider: webSocketMock)
    }

    func testFetchConfig() async throws {
        // Given
        webSocketMock.sendReturn = (.zero, ServerConfig(
            latitude: 1,
            longitude: 2,
            elevation: 3,
            locationName: "name",
            timeZone: "timezone",
            version: "1.2.3",
            state: "on"
        ))

        // When
        let config = try await subject.fetchConfig()

        // Then
        XCTAssertEqual(config.latitude, 1)
        XCTAssertEqual(config.longitude, 2)
        XCTAssertEqual(config.elevation, 3)
        XCTAssertEqual(config.locationName, "name")
        XCTAssertEqual(config.timeZone, "timezone")
        XCTAssertEqual(config.version, "1.2.3")
        XCTAssertEqual(config.state, "on")
        XCTAssertNotNil(webSocketMock.messageSent as? FetchConfigMessage)
    }

    func testFetchStates() async throws {
        // Given
        webSocketMock.sendReturn = (.zero, [
            EntityState(id: "1", state: "on", name: "name1"),
            EntityState(id: "2", state: "off", name: "name2")
        ])

        // When
        let states = try await subject.fetchStates()

        // Then
        XCTAssertEqual(states.count, 2)
        XCTAssertEqual(states[0].id, "1")
        XCTAssertEqual(states[1].state, "off")
        XCTAssertEqual(states[0].name, "name1")
        XCTAssertNotNil(webSocketMock.messageSent as? FetchStateMessage)
    }
}
