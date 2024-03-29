//
//  CommandRepositoryImplTests.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Combine
import XCTest
@testable import Data

final class CommandRepositoryImplTests: XCTestCase {

    private var commandRemoteDataSourceMock: CommandRemoteDataSourceMock!
    var subject: CommandRepositoryImpl!

    override func setUp() {
        super.setUp()

        commandRemoteDataSourceMock = CommandRemoteDataSourceMock()
        subject = CommandRepositoryImpl(commandRemoteDataSource: commandRemoteDataSourceMock)
    }

    func testFireEventWithData() async throws {
        // Given
        struct EventData: Encodable { let test = "test" }

        // When
        try await subject.fireEvent(eventType: "event type", eventData: EventData())

        // Then
        let params = commandRemoteDataSourceMock.fireEventParamsCalled
        let eventData = params?.eventData as? EventData
        XCTAssertEqual(params?.eventType, "event type")
        XCTAssertEqual(eventData?.test, "test")
    }

    func testFireEventWithoutData() async throws {
        // When
        try await subject.fireEvent(eventType: "event type")

        // Then
        let params = commandRemoteDataSourceMock.fireEventParamsCalled
        XCTAssertEqual(params?.eventType, "event type")
        XCTAssertNil(params?.eventData)
    }

    func testCallServiceForEntityWithData() async throws {
        // Given
        struct ServiceData: Encodable { let test = "test" }

        // When
        try await subject.callService(entityID: "light.id", service: .turnOn, serviceData: ServiceData())

        // Then
        let params = commandRemoteDataSourceMock.callServiceParamsCalled
        let serviceData = params?.serviceData as? ServiceData
        XCTAssertEqual(params?.domain, "light")
        XCTAssertEqual(params?.service, "turn_on")
        XCTAssertEqual(params?.entityID, "light.id")
        XCTAssertEqual(serviceData?.test, "test")
    }

    func testCallServiceForEntityWithoutData() async throws {
        // When
        try await subject.callService(entityID: "light.id", service: .turnOn)

        // Then
        let params = commandRemoteDataSourceMock.callServiceParamsCalled
        XCTAssertEqual(params?.domain, "light")
        XCTAssertEqual(params?.service, "turn_on")
        XCTAssertEqual(params?.entityID, "light.id")
        XCTAssertNil(params?.serviceData)
    }

    func testCallServiceForDomainWithData() async throws {
        // Given
        struct ServiceData: Encodable { let test = "test" }

        // When
        try await subject.callService(domain: .climate, service: .turnOn, serviceData: ServiceData())

        // Then
        let params = commandRemoteDataSourceMock.callServiceParamsCalled
        let serviceData = params?.serviceData as? ServiceData
        XCTAssertEqual(params?.domain, "climate")
        XCTAssertEqual(params?.service, "turn_on")
        XCTAssertEqual(serviceData?.test, "test")
        XCTAssertNil(params?.entityID)
    }

    func testCallServiceForDomainWithoutData() async throws {
        // When
        try await subject.callService(domain: .climate, service: .turnOn)

        // Then
        let params = commandRemoteDataSourceMock.callServiceParamsCalled
        XCTAssertEqual(params?.domain, "climate")
        XCTAssertEqual(params?.service, "turn_on")
        XCTAssertNil(params?.entityID)
        XCTAssertNil(params?.serviceData)
    }
}

// MARK: - CommandRemoteDataSourceMock

private class CommandRemoteDataSourceMock: CommandRemoteDataSource {

    var fireEventParamsCalled: (eventType: String, eventData: Any?)?
    var callServiceParamsCalled: (domain: String, service: String, entityID: String?, serviceData: Any?)?

    func fireEvent<T>(eventType: String, eventData: T?) async throws where T : Encodable {
        fireEventParamsCalled = (eventType, eventData)
    }

    func callService<T>(domain: String, service: String, entityID: String?, serviceData: T?) async throws where T : Encodable {
        callServiceParamsCalled = (domain, service, entityID, serviceData)
    }
}
