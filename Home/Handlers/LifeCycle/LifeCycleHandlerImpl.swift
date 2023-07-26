//
//  LifeCycleHandler.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Data
import Domain
import Foundation
import SwiftUI

class LifeCycleHandlerImpl<DashboardS: DashboardService, EntityS: EntityService>: LifeCycleHandler {

    private weak var coordinator: Coordinator?
    private let dashboardsService: DashboardS
    private let entityService: EntityS
    private let webSocket: WebSocketProvider

    init(
        coordinator: Coordinator,
        dashboardsService: DashboardS,
        entityService: EntityS,
        webSocket: WebSocketProvider
    ) {
        self.coordinator = coordinator
        self.dashboardsService = dashboardsService
        self.entityService = entityService
        self.webSocket = webSocket
    }
}

// MARK: Private Methods

extension LifeCycleHandlerImpl {

    private func persist() {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            guard await webSocket.isConnected() else {
                semaphore.signal()
                return
            }

            try? await dashboardsService.persist()
            try? await entityService.persist()
            semaphore.signal()
        }
        semaphore.wait()
    }
}

// MARK: Public Methods

extension LifeCycleHandlerImpl {

    func appStateDidChange(_ state: AppState) {
        switch state {
        case .foreground:
            break
        case .background:
            persist()
        }
    }
}
