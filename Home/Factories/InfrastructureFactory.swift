////
////  InfrastructureFactory.swift
////  Home
////
////  Created by Breno Aquino on 19/07/23.
////
//
//import Data
//import Foundation
//
//class InfrastructureFactory {
//
//    private let webSocketProvider: WebSocketProvider
//    private let databaseProvider: DatabaseProvider
//
//    init() {
//        webSocketProvider = try! WebSocket(url: AppEnvironment.homeAssistantURL, token: AppEnvironment.authToken)
//        databaseProvider = UserDefaultsDatabaseProvider()
//    }
//
//    func webSocket() -> WebSocketProvider {
//        webSocketProvider
//    }
//
//    func database() -> DatabaseProvider {
//        databaseProvider
//    }
//}
