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

// MARK: - Interface

enum AppState {
    case foreground
    case background
    case terminate
}

protocol LifeCycleHandler {

    func appStateDidChange(_ state: AppState)
}

// MARK: - Implementation

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

    private func prepareToBackground() {
        coordinator?.root = .staticLaunch
        persist()
    }

    private func prepareToForeground() {
        guard coordinator?.root != .launch else { return }
        coordinator?.root = .launch
    }

    private func persist() {
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            try? await dashboardsService.persist()
            try? await entityService.persistHiddenEntities()
            await webSocket.disconnect()
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
            prepareToForeground()
        case .background:
            prepareToBackground()
        case .terminate:
            persist()
        }
    }
}
