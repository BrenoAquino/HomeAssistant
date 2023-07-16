////
////  StateRemoteDataSourceImpl.swift
////  
////
////  Created by Breno Aquino on 14/07/23.
////
//
//import Foundation
//
//public class StateRemoteDataSourceImpl {
//
//    let webSocketProvider: WebSocketProvider
//
//    public init(webSocketProvider: WebSocketProvider) {
//        self.webSocketProvider = webSocketProvider
//    }
//}
//
//// MARK: - StateRemoteDataSource
//
//extension StateRemoteDataSourceImpl {
//
//    public func subscribeToStateChanged() async throws {
//        try await webSocketProvider.send(message: SubscribeToStateChanged())
//    }
//
//    public func setState(domain: String, service: String, entityID: String) async throws {
//        try await webSocketProvider.send(message: SetStateMessage(domain: domain, service: service, entityID: entityID))
//    }
//
//    public func fetchStates() async throws -> [EntityState] {
//        try await webSocketProvider.send(message: FetchStateMessage())
//    }
//}
