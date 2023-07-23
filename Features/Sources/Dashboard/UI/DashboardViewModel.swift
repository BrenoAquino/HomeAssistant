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

// MARK: - Interface

public protocol DashboardViewModel: ObservableObject {

    var editModel: Bool { get set }
    var selectedDashboard: Dashboard? { get set }
    var dashboards: [Dashboard] { get set }

    var didSelectAddDashboard: (() -> Void)? { get set }
    var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)? { get set }

    func didSelectAdd()
    func didSelectEdit(_ dashboard: Dashboard)
}

// MARK: - Implementation

public class DashboardViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardViewModel {

    private var cancellable: Set<AnyCancellable> = .init()

    // MARK: Services

    @ObservedObject private var entityService: EntityS
    @ObservedObject var dashboardService: DashboardS

    // MARK: Redirects

    public var didSelectAddDashboard: (() -> Void)?
    public var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)?

    // MARK: Publishers

    @Published public var editModel: Bool = false
    @Published public var selectedDashboard: Dashboard?
    @Published private(set) var entities: Int = .zero

    // MARK: Gets

    public var dashboards: [Dashboard] {
        get { dashboardService.dashboards }
        set {
            dashboardService.dashboards = newValue
            objectWillChange.send()
        }
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS) {
        self.dashboardService = dashboardService
        self.entityService = entityService

        setupObservers()
    }
}

// MARK: Private Methods

extension DashboardViewModelImpl {

    private func setupObservers() {
        $selectedDashboard
            .compactMap { $0 }
            .sink { [weak self] dashboard in
                self?.entities = dashboard.entitiesIDs.count
                self?.objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

// MARK: Public Methods

extension DashboardViewModelImpl {

    public func didSelectAdd() {
        didSelectAddDashboard?()
    }

    public func didSelectEdit(_ dashboard: Dashboard) {
        guard let dashboard = dashboards.first(where: { $0.name == dashboard.name }) else { return }
        didSelectEditDashboard?(dashboard)
        editModel = false
    }
}
