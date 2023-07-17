//
//  FetcherRepositoryImplTests.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Combine
import XCTest
@testable import Data

final class FetcherRepositoryImplTests: XCTestCase {

    private var fetcherRemoteDataSourceMock: FetcherRemoteDataSourceMock!
    var subject: FetcherRepositoryImpl!

    override func setUp() {
        super.setUp()

        fetcherRemoteDataSourceMock = FetcherRemoteDataSourceMock()
        subject = FetcherRepositoryImpl(fetcherRemoteDataSource: fetcherRemoteDataSourceMock)
    }

    func testFetchConfig() async throws {
        // When
        let config = try await subject.fetchConfig()

        // Then
        XCTAssertEqual(config.locationName, "name")
        XCTAssertEqual(config.state, .online)
    }

    func testFetchStates() async throws {
        // When
        let states = try await subject.fetchStates()

        // Then
        XCTAssertEqual(states.count, 2)
        XCTAssertEqual(states[0].id, "light.id1")
        XCTAssertEqual(states[0].domain, .light)
        XCTAssertEqual(states[0].state, .on)
        XCTAssertEqual(states[0].name, "name1")
    }
}

// MARK: - CommandRemoteDataSourceMock

private class FetcherRemoteDataSourceMock: FetcherRemoteDataSource {
    
    func fetchConfig() async throws -> ServerConfig {
        ServerConfig(
            latitude: 1,
            longitude: 2,
            elevation: 3,
            locationName: "name",
            timeZone: "timezone",
            version: "1.2.3",
            state: "RUNNING"
        )
    }

    func fetchStates() async throws -> [GenericEntity] {
        [
            .init(id: "light.id1", state: "on", name: "name1"),
            .init(id: "light.id2", state: "off", name: "name2")
        ]
    }
}

// MARK: - GenericEntity+init

private extension GenericEntity {

    init(id: String, state: String, name: String) {
        self.init(
            id: id,
            state: state,
            attributes: .init(
                name: name,
                hvacModes: nil,
                fanModes: nil,
                minTemperature: nil,
                maxTemperature: nil,
                targetTemperature: nil,
                temperatureStep: nil,
                currentHvac: nil,
                currentFanModel: nil,
                currentTemperature: nil,
                currentPercentage: nil,
                percentageStep: nil
            )
        )
    }
}
