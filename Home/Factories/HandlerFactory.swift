//
//  HandlerFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Foundation

protocol HandlerFactory {

    func webSocketHandler(coordinator: Coordinator) -> WebSocketHandler
}
