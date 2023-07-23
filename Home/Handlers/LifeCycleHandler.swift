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

    private let dashboardsService: DashboardS
    private let entityService: EntityS

    init(dashboardsService: DashboardS, entityService: EntityS) {
        self.dashboardsService = dashboardsService
        self.entityService = entityService
    }
}

extension LifeCycleHandlerImpl {

    func appStateDidChange(_ state: AppState) {
        guard state == .background || state == .terminate else { return }
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            try? await dashboardsService.persist()
            try? await entityService.persistHiddenEntities()
            semaphore.signal()
        }
        semaphore.wait()
    }
}
