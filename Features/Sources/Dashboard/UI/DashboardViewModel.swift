//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Preview
import Combine
import Common
import Domain
import SwiftUI

// MARK: - Interface

public protocol DashboardViewModel: ObservableObject {

    var editModel: Bool { get set }
    var selectedDashboardName: String? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }

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
    @Published public var selectedDashboardName: String?

    // MARK: Gets

    public var dashboards: [Dashboard] {
        get { dashboardService.dashboards }
        set {
            dashboardService.dashboards = newValue
            objectWillChange.send()
        }
    }

    public var currentDashboard: Dashboard? {
        dashboards.first(where: { $0.name == selectedDashboardName })
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS) {
        self.dashboardService = dashboardService
        self.entityService = entityService

        setupData()
        setupObservers()
    }
}

// MARK: Private Methods

extension DashboardViewModelImpl {

    private func setupData() {
        selectedDashboardName = dashboards.first?.name
    }

    private func setupObservers() {
        dashboardService.forward(objectWillChange).store(in: &cancellable)
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
