//
//  Environment.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

enum Environment {

    static let authToken: String = {
        Bundle.main.infoDictionary?["Auth Token"] as? String ?? ""
    }()

    static let homeAssistantURL: String = {
        let host = Bundle.main.infoDictionary?["Home Assistant URL"] as? String ?? ""
        return "ws://\(host)/api/websocket"
    }()
}
