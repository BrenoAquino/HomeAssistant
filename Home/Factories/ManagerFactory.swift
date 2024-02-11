//
//  ManagerFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Foundation

protocol ManagerFactory {
    /// Return an instance of web socket manager
    func webSocketManager(coordinator: Coordinator) -> WebSocketManager
}
