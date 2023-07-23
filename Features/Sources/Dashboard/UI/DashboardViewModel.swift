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

    // MARK: Services

    private let entityService: EntityService
    private let dashboardService: DashboardService

    // MARK: Redirects

    public var didSelectAddDashboard: (() -> Void)?
    public var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)?

    // MARK: Publishers

    @Published var editModel: Bool = false
    @Published var selectedDashboard: Dashboard?
    @Published private(set) var entities: Int = .zero

    // MARK: Gets

    var dashboards: [Dashboard] {
        get { dashboardService.dashboards.value }
        set { dashboardService.dashboards.send(newValue) }
    }

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
            .sink { [weak self] _ in
                if self?.selectedDashboard == nil {
                    self?.selectedDashboard = self?.dashboards.first
                }
                self?.objectWillChange.send()
            }
            .store(in: &cancellable)

        $selectedDashboard
            .compactMap { $0 }
            .sink { [weak self] dashboard in
                self?.entities = dashboard.entitiesIDs.count
            }
            .store(in: &cancellable)
    }
}

// MARK: - Interfaces

extension DashboardViewModel {

    func didSelectAdd() {
        didSelectAddDashboard?()
    }

    func didSelectEdit(_ dashboard: any DashboardUI) {
        guard let dashboard = dashboards.first(where: { $0.name == dashboard.name }) else { return }
        didSelectEditDashboard?(dashboard)
        editModel = false
    }
}
