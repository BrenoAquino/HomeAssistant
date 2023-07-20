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
    private var dashboardUpdateCancellable: AnyCancellable?

    public var didSelectAddDashboard: (() -> Void)?
    public var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)?

    // MARK: Publishers

    @Published var editModel: Bool = false
    @Published var dashboards: [Dashboard] = []
    @Published var selectedDashboard: String = ""

    // MARK: Services

    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService) {
        self.dashboardService = DashboardServiceMock()

        setupObservers()
    }
}

// MARK: - Private Methods

extension DashboardViewModel {

    private func setupObservers() {
        dashboardService
            .dashboards
            .filter { [weak self] incomingDashboards in
                guard let self else { return false }
                return incomingDashboards.map { $0.name } != self.dashboards.map { $0.name }
            }
            .sink { [weak self] in
                self?.dashboards = $0
                self?.setupDashboardsUpdate()
            }
            .store(in: &cancellable)
    }

    private func setupDashboardsUpdate() {
        guard dashboardUpdateCancellable == nil else { return }

        selectedDashboard = dashboards.first?.name ?? ""
        dashboardUpdateCancellable = $dashboards
            .filter { [weak self] incomingDashboards in
                guard let self else { return false }
                return incomingDashboards.map { $0.name } != self.dashboardService.dashboards.value.map { $0.name }
            }
            .sink { [weak self] in
                self?.dashboardService.updateAll(dashboards: $0)
            }
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

    func didSelectEdit(_ dashboard: any DashboardUI) {
        guard let dashboard = dashboards.first(where: { $0.name == dashboard.name }) else { return }
        didSelectEditDashboard?(dashboard)
        editModel = false
    }
}
