//
//  DashboardViewModelImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Common
import Domain
import SwiftUI

public class DashboardViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardViewModel {

    private var cancellable: Set<AnyCancellable> = .init()

    // MARK: Services

    @ObservedObject private var entityService: EntityS
    @ObservedObject var dashboardService: DashboardS

    // MARK: Redirects

    public var didSelectConfig: (() -> Void)?
    public var didSelectAddDashboard: (() -> Void)?
    public var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)?

    // MARK: Publishers

    @Published public var editModel: Bool = false
    @Published public var selectedDashboardIndex: Int?

    // MARK: Gets

    public var dashboards: [Dashboard] {
        get { dashboardService.dashboards }
        set {
            dashboardService.dashboards = newValue
            objectWillChange.send()
        }
    }

    public var currentDashboard: Dashboard? {
        guard
            let selectedDashboardIndex,
            selectedDashboardIndex < dashboards.count,
            selectedDashboardIndex >= 0
        else { return nil }
        return dashboards[selectedDashboardIndex]
    }

    public var entities: [any Entity] {
        guard let currentDashboard else { return [] }
        return currentDashboard.entitiesIDs.compactMap { self.entityService.entities[$0] }
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS) {
        self.dashboardService = dashboardService
        self.entityService = entityService

        setupData()
        setupForwards()
    }
}

// MARK: - Private Methods

extension DashboardViewModelImpl {

    private func setupData() {
        selectedDashboardIndex = dashboards.count > 0 ? 1 : nil
    }

    private func setupForwards() {
        dashboardService.forward(objectWillChange, on: RunLoop.main).store(in: &cancellable)
        entityService.forward(objectWillChange, on: RunLoop.main).store(in: &cancellable)
    }
}

// MARK: - Public Methods

extension DashboardViewModelImpl {

    public func didClickAdd() {
        didSelectAddDashboard?()
    }

    public func didClickEdit(_ dashboard: Dashboard) {
        didSelectEditDashboard?(dashboard)
        editModel = false
    }

    public func didClickConfig() {
        didSelectConfig?()
    }

    public func didClickUpdateLightState(_ lightEntityUI: LightEntityUI, newState: LightStateUI) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: lightEntityUI.id)
            } catch {
                Logger.log(level: .error, "Could not execute \(String(describing: service))")
            }
        }
    }
}
