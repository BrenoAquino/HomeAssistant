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

enum AppState {
    case foreground
    case background
    case terminate
}

class LifeCycleHandler {

    private let dashboardsService: DashboardService

    init(dashboardsService: DashboardService) {
        self.dashboardsService = dashboardsService
    }
}

extension LifeCycleHandler {

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
