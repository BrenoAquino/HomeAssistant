//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Preview
import Domain
import Foundation

public class DashboardViewModel: ObservableObject {

    // MARK: Publishers

    @Published private(set) var dashboards: [Dashboard] = []
    @Published private(set) var selectedIndex: Int = 0

    // MARK: Services

    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService) {
        self.dashboardService = DashboardServiceMock()
        dashboards = self.dashboardService.dashboards
    }
}

// MARK: - Interfaces

extension DashboardViewModel {

    func selectDashboard(_ dashboard: any DashboardUI, index: Int) {
        guard index < dashboards.count && index >= 0 else { return }
        selectedIndex = index
    }
}
