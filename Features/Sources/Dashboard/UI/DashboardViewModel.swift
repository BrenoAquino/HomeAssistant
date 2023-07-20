//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Preview
import Combine
import Domain
import Foundation

public class DashboardViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = .init()
    public var didSelectAddDashboard: (() -> Void)?

    // MARK: Publishers

    @Published var editModel: Bool = false
    @Published var dashboards: [Dashboard] = []
    @Published var selectedDashboard: String = ""

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
            .sink { [weak self] in
                self?.dashboards = $0
                self?.selectedDashboard = $0.first?.name ?? ""
            }
            .store(in: &cancellable)
    }
}

// MARK: - Interfaces

extension DashboardViewModel {

    func removeDashboard(_ dashboard: any DashboardUI) {
        dashboardService.delete(dashboardName: dashboard.name)
    }

    func didSelectAdd() {
        didSelectAddDashboard?()
    }
}
