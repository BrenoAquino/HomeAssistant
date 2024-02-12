//
//  DashboardViewModelImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Combine
import Common
import Domain
import SwiftUI

public class DashboardViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardViewModel {
    public var externalFlows: DashboardExternalFlow?
    private var cancellable: Set<AnyCancellable> = .init()

    // MARK: Services

    private var entityService: EntityS
    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var dashboards: [Dashboard] = []
    @Published public var selectedDashboardName: String?
    @Published public var widgets: [WidgetData] = []
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Gets

    private  var currentDashboard: Dashboard? {
        guard let selectedDashboardName else { return nil }
        return dashboardService.dashboards[selectedDashboardName]
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS) {
        self.dashboardService = dashboardService
        self.entityService = entityService

        setupData()
        setupServicesObservers()
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension DashboardViewModelImpl {
    private func setupData() {
        dashboards = dashboardService.dashboardOrder.compactMap {
            dashboardService.dashboards[$0]
        }
        selectedDashboardName = dashboards.first?.name
    }

    private func setupServicesObservers() {
        entityService
            .entitiesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] entities in
                guard let self else { return }
                self.updateWidgets(
                    entities,
                    self.dashboardService.dashboards,
                    self.selectedDashboardName
                )
            }
            .store(in: &cancellable)

        dashboardService
            .dashboardsPublisher
            .filter { [weak self] dashboards in
                guard let self else { return false }
                return isDifferent(
                    dict: dashboards,
                    array: self.dashboards
                )
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] dashboards in
                guard let self else { return }
                self.dashboards = self.dashboardService.dashboardOrder.compactMap { dashboards[$0] }
                if self.selectedDashboardName == nil {
                    self.selectedDashboardName = self.dashboards.first?.name
                }
                self.updateWidgets(
                    self.entityService.entities,
                    dashboards,
                    selectedDashboardName
                )
            }
            .store(in: &cancellable)
    }

    private func setupUIObservers() {
        $selectedDashboardName
            .dropFirst()
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedDashboardName in
                guard let self else { return }
                self.updateWidgets(
                    self.entityService.entities,
                    self.dashboardService.dashboards,
                    selectedDashboardName
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardViewModelImpl {
    private func isDifferent(dict: [String: Dashboard], array: [Dashboard]) -> Bool {
        if array.count != dict.count {
            return true
        }
        for element in array {
            if dict[element.name] == nil {
                return true
            } else if let widgets = dict[element.name]?.widgetConfigs, Set(widgets) != Set(element.widgetConfigs) {
                return true
            }
        }
        return false
    }

    private func setError(message: String) {
        toastData = .init(type: .error, title: message)
    }

    private func updateWidgets(
        _ entities: [String : any Entity],
        _ dashboards: [String : Dashboard],
        _ dashboardName: String?
    ) {
        guard 
            let dashboardName,
            let selectedDashboard = dashboards[dashboardName]
        else {
            widgets = []
            return
        }
        widgets = selectedDashboard.widgetConfigs.compactMap { config in
            if let entity = entities[config.entityID] {
                return WidgetData(config: config, entity: entity)
            }
            return nil
        }
    }
}

// MARK: Clicks

extension DashboardViewModelImpl {
    public func didClickConfig() {
        externalFlows?.didSelectConfig()
    }

    public func didClickEdit() {
        guard let currentDashboard else { return }
        externalFlows?.didSelectEditDashboard(currentDashboard)
    }

    public func didClickAddDashboard() {
        externalFlows?.didSelectAddDashboard()
    }

    public func didClickAddWidget() {
        guard let currentDashboard else { return }
        externalFlows?.didSelectAddWidget(currentDashboard)
    }
}

// MARK: Update States

extension DashboardViewModelImpl {
    public func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: lightEntity.id)
            } catch {
                setError(message: Localizable.lightError.value)
            }
        }
    }

    public func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: fanEntity.id)
            } catch {
                setError(message: Localizable.lightError.value)
            }
        }
    }
}
