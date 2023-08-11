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
import Combine

class WebSocketHandlerImpl: WebSocketHandler {

    private weak var coordinator: Coordinator?
    private var webSocketProvider: WebSocketProvider?
    private var cancellable: Set<AnyCancellable> = []

    init(
        coordinator: Coordinator,
        webSocketProvider: WebSocketProvider
    ) {
        self.coordinator = coordinator
        self.webSocketProvider = webSocketProvider

        setupWebSocketRetry()
    }
}

// MARK: Setup Methods

extension WebSocketHandlerImpl {

    private func setupWebSocketRetry() {
        webSocketProvider?
            .stateChanged
            .filter { $0 == .offline }
            .sink { [weak self] _ in self?.coordinator?.setRoot(.launch) }
            .store(in: &cancellable)
    }
}
