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

class LifeCycleHandlerImpl<DashboardS: DashboardService>: LifeCycleHandler {

    private let dashboardsService: DashboardS

    init(dashboardsService: DashboardS) {
        self.dashboardsService = dashboardsService
    }
}

extension LifeCycleHandlerImpl {

    func appStateDidChange(_ state: AppState) {
        guard state == .background || state == .terminate else { return }
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            try? await dashboardsService.persist()
            semaphore.signal()
        }
        semaphore.wait()
    }
}
