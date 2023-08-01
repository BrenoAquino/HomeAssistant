//
//  WebSocketHandlerImpl.swift
//  Home
//
//  Created by Breno Aquino on 25/07/23.
//

import Data
import Domain
import Foundation
import SwiftUI

class WebSocketHandlerImpl: WebSocketHandler {

    private weak var coordinator: Coordinator?

    init(
        coordinator: Coordinator
    ) {
        self.coordinator = coordinator
    }
}

// MARK: Public Methods

extension WebSocketHandlerImpl {

    func webSocketDidDisconnect() {
//        self.coordinator?.block(.launch(style: .default))
    }
}
