//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Domain
import Foundation

public class DashboardViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = .init()
    public var didSelectAddDashboard: (() -> Void)?

    // MARK: Publishers

    @Published private(set) var dashboards: [Dashboard] = []
    @Published private(set) var selectedIndex: Int = 0

    // MARK: Services

    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService) {
        self.dashboardService = dashboardService

        setupObservers()
    }
}

// MARK: - Private Methods

extension DashboardViewModel {

    private func setupObservers() {
        dashboardService
            .dashboards
            .sink { [weak self] in self?.dashboards = $0 }
            .store(in: &cancellable)
    }
}

// MARK: - Interfaces

extension DashboardViewModel {

    func selectDashboard(_ dashboard: any DashboardUI, index: Int) {
        guard index < dashboards.count && index >= 0 else { return }
        selectedIndex = index
    }

    func didSelectAdd() {
        didSelectAddDashboard?()
    }
}
