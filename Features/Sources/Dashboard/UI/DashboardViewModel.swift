//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

public class DashboardViewModel: ObservableObject {

    // MARK: Publishers

    @Published private(set) var dashboards: [Dashboard] = []

    // MARK: Services

    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService) {
        self.dashboardService = dashboardService
        dashboards = dashboardService.dashboards
    }
}

// MARK: - Private Methods
