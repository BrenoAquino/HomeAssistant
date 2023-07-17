//
//  SubscriptionRepositoryImplTests.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Combine
import Domain
import XCTest
@testable import Data

final class SubscriptionRepositoryImplTests: XCTestCase {

    private var cancellable: Set<AnyCancellable>!
    private var subscriptionRemoteDataSourceMock: SubscriptionRemoteDataSourceMock!
    var subject: SubscriptionRepositoryImpl!

    override func setUp() {
        super.setUp()

        cancellable = []
        subscriptionRemoteDataSourceMock = SubscriptionRemoteDataSourceMock()
        subject = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: subscriptionRemoteDataSourceMock)
    }

    func testUnsubscribe() async throws {
        // When
        try await subject.unsubscribe(operationID: .zero)

        // Then
        XCTAssertTrue(subscriptionRemoteDataSourceMock.unsubscribeCalled)
    }

    func testSubscribeToEvent() async throws {
        // When
        let id = try await subject.subscribeToEvents(eventType: .stateChanged)

        // Then
        XCTAssertEqual(id, .zero)
        XCTAssertTrue(subscriptionRemoteDataSourceMock.subscribeToEventsCalled)
    }

    func testReceiveStateChangedWithCorrectDataEvent() async throws {
        // Given
        let expectation = XCTestExpectation(description: "state changed event")
        var stateChanged: Domain.StateChangedEvent?
        let data = """
        {
            "event_type": "state_changed",
            "old_state": {
                "entity_id": "light.id",
                "state": "on",
                "attributes": {
                    "friendly_name": "Light I"
                }
            },
            "new_state": {
                "entity_id": "light.id",
                "state": "off",
                "attributes": {
                    "friendly_name": "Light I"
                }
            }
        }
        """.data(using: .utf8)!
        subject
            .stateChangedEvent
            .sink { _ in
            } receiveValue: { stateChangedEvent in
                stateChanged = stateChangedEvent
                expectation.fulfill()
            }
            .store(in: &cancellable)

        // When
        subscriptionRemoteDataSourceMock.topic.send(data)

        // Then
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertNotNil(stateChanged)
        XCTAssertEqual(stateChanged?.id, "light.id")
        XCTAssertEqual(stateChanged?.name, "Light I")
        XCTAssertEqual(stateChanged?.oldState, .on)
        XCTAssertEqual(stateChanged?.newState, .off)
    }

    func testReceiveStateChangedWithDifferentIDs() async throws {
        // Given
        var error: Error?
        let expectation = XCTestExpectation(description: "state changed event")
        let data = """
        {
            "event_type": "state_changed",
            "old_state": { "entity_id": "light.id", "state": "on", "attributes": { "friendly_name": "Light I" }},
            "new_state": { "entity_id": "light.id2", "state": "off", "attributes": { "friendly_name": "Light I" }},
        }
        """.data(using: .utf8)!
        subject
            .stateChangedEvent
            .sink { completion in
                if case .failure(let failure) = completion {
                    error = failure
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancellable)

        // When
        subscriptionRemoteDataSourceMock.topic.send(data)

        // Then
        await fulfillment(of: [expectation], timeout: 5)
        let converterError = error as? ConverterError
        XCTAssertNotNil(converterError)
        XCTAssertTrue(converterError?.message.contains("StateChangedEvent.toDomain") == true)
    }

    func testReceiveStateChangedWithDifferentNames() async throws {
        // Given
        var error: Error?
        let expectation = XCTestExpectation(description: "state changed event")
        let data = """
        {
            "event_type": "state_changed",
            "old_state": { "entity_id": "light.id", "state": "on", "attributes": { "friendly_name": "Light I" }},
            "new_state": { "entity_id": "light.id", "state": "off", "attributes": { "friendly_name": "Light I2" }},
        }
        """.data(using: .utf8)!
        subject
            .stateChangedEvent
            .sink { completion in
                if case .failure(let failure) = completion {
                    error = failure
                    expectation.fulfill()
                }
            } receiveValue: { _ in }
            .store(in: &cancellable)

        // When
        subscriptionRemoteDataSourceMock.topic.send(data)

        // Then
        await fulfillment(of: [expectation], timeout: 5)
        let converterError = error as? ConverterError
        XCTAssertNotNil(converterError)
        XCTAssertTrue(converterError?.message.contains("StateChangedEvent.toDomain") == true)
    }

    func testReceiveUnknownEvent() async throws {
        // Given
        let expectation = XCTestExpectation(description: "state changed event")
        expectation.isInverted = true
        let data = """
        {
            "event_type": "another_event",
            "old_state": { "entity_id": "light.id", "state": "on", "attributes": { "friendly_name": "Light I" }},
            "new_state": { "entity_id": "light.id", "state": "off", "attributes": { "friendly_name": "Light I" }},
        }
        """.data(using: .utf8)!
        subject
            .stateChangedEvent
            .sink { _ in } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellable)

        // When
        subscriptionRemoteDataSourceMock.topic.send(data)

        // Then
        await fulfillment(of: [expectation], timeout: 5)
    }
}

// MARK: - SubscriptionRemoteDateSourceMock

private class SubscriptionRemoteDataSourceMock: SubscriptionRemoteDataSource {

    var topic: PassthroughSubject<Data, Never> = .init()
    var unsubscribeCalled = false
    var subscribeToEventsCalled = false

    var event: AnyPublisher<Data, Never> { topic.eraseToAnyPublisher() }

    func unsubscribe(operationID: Int) async throws {
        unsubscribeCalled = true
    }

    func subscribeToEvents(eventType: String) async throws -> Int {
        subscribeToEventsCalled = true
        return .zero
    }
}
