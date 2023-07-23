//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Preview
import Combine
import Domain
import SwiftUI

public class DashboardViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = .init()
    private var dashboardUpdateCancellable: AnyCancellable?

    public var didSelectAddDashboard: (() -> Void)?
    public var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)?

    // MARK: Publishers

    @Published var editModel: Bool = false
    @Published var dashboards: [Dashboard] = []
    @Published var selectedDashboard: Dashboard?
    @Published private(set) var entities: Int = .zero

    // MARK: Services

    private let entityService: EntityService
    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService, entityService: EntityService) {
        self.dashboardService = dashboardService
        self.entityService = entityService

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
                self?.selectedDashboard = self?.dashboards.first
                print("dashboardService.dashboards.sink")
            }
            .store(in: &cancellable)

        $selectedDashboard
            .compactMap { $0 }
            .sink { [weak self] dashboard in
                self?.entities = dashboard.entitiesIDs.count
                print("$selectedDashboard.sink \(String(describing: self?.entities))")
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

    func didSelectEdit(_ dashboard: any DashboardUI) {
        guard let dashboard = dashboards.first(where: { $0.name == dashboard.name }) else { return }
        didSelectEditDashboard?(dashboard)
        editModel = false
    }
}
