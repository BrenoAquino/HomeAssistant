//
//  InfrastructureFactory.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Data
import Foundation

protocol InfrastructureFactory {

    func webSocket() -> WebSocketProvider
    func database() -> DatabaseProvider 
}
