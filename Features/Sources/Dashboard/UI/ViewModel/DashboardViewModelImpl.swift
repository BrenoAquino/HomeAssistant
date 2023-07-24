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

    public var delegate: DashboardExternalFlow?
    private var cancellable: Set<AnyCancellable> = .init()

    // MARK: Services

    @ObservedObject private var entityService: EntityS
    @ObservedObject var dashboardService: DashboardS

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
        delegate?.didSelectAddDashboard()
    }

    public func didClickEdit(_ dashboard: Dashboard) {
        delegate?.didSelectEditDashboard(dashboard)
        editModel = false
    }

    public func didClickConfig() {
        delegate?.didSelectConfig()
    }

    public func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: lightEntity.id)
            } catch {
                Logger.log(level: .error, "Could not execute \(String(describing: service))")
            }
        }
    }
}
