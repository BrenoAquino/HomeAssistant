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

    public var delegate: DashboardExternalFlow?
    private var cancellable: Set<AnyCancellable> = .init()
    private var dashboardNameToDelete: String?
    private var widgetIDToDelete: String?

    // MARK: Services

    private var entityService: EntityS
    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var editModel: Bool = false
    @Published public var dashboards: [Dashboard] = []
    @Published public var selectedDashboardName: String?
    @Published public var widgets: [WidgetData] = []
    @Published public var removeDashboardAlert: Bool = false
    @Published public var removeWidgetAlert: Bool = false
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Gets

    private  var currentDashboard: Dashboard? {
        guard let selectedDashboardName else { return nil }
        return dashboardService.dashboards.value[selectedDashboardName]
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS) {
        self.dashboardService = dashboardService
        self.entityService = entityService

        setupData()
        setupServiceObservers()
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension DashboardViewModelImpl {

    private func setupData() {
        dashboards = dashboardService.dashboardOrder.value.compactMap {
            dashboardService.dashboards.value[$0]
        }
        selectedDashboardName = dashboards.first?.name
    }

    private func setupServiceObservers() {
        // Update the entity list when it changes
        entityService
            .entities
            .receive(on: RunLoop.main)
            .sink { [weak self] entities in
                guard let self else { return }
                self.setWidgets(
                    entities,
                    self.dashboardService.dashboards.value,
                    self.selectedDashboardName
                )
            }
            .store(in: &cancellable)

        // Update the dashboard when we get any change on it
        dashboardService
            .dashboards
            .filter { [weak self] dashboards in
                guard let self else { return false }
                return isDifferent(dict: dashboards, array: self.dashboards)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] dashboards in
                guard let self else { return }
                self.dashboards = self.dashboardService.dashboardOrder.value.compactMap { dashboards[$0] }
                if self.selectedDashboardName == nil {
                    self.selectedDashboardName = self.dashboards.first?.name
                }
                self.setWidgets(
                    self.entityService.entities.value,
                    dashboards,
                    selectedDashboardName
                )
            }
            .store(in: &cancellable)
    }

    private func setupUIObservers() {
        // Update current dashboard when change it
        $selectedDashboardName
            .dropFirst()
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                guard let self else { return }
                print("$selectedDashboardName sink \(Unmanaged.passUnretained(self).toOpaque()) \(name)")
                self.setWidgets(
                    self.entityService.entities.value,
                    self.dashboardService.dashboards.value,
                    name
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardViewModelImpl {

    private func isDifferent(
        dict: [String : Dashboard],
        array: [Dashboard]
    ) -> Bool {
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

    private func setError(
        message: String,
        logMessage: String? = nil
    ) {
        toastData = .init(type: .error, title: message)
        Logger.log(level: .error, logMessage ?? message)
    }

    private func setWidgets(
        _ entities: [String : any Entity],
        _ dashboards: [String : Dashboard],
        _ dashboardName: String?
    ) {
        guard let dashboardName, let selectedDashboard = dashboards[dashboardName] else {
            widgets = []
            return
        }

        widgets = selectedDashboard.widgetConfigs.compactMap { config in
            if let entity = entities[config.entityID] {
                return (config, entity)
            }
            return nil
        }
    }
}

// MARK: - Public Methods

extension DashboardViewModelImpl {

    public func deleteRequestedDashboard() {
        guard let dashboardNameToDelete else { return }
        try? dashboardService.delete(dashboardName: dashboardNameToDelete)
    }

    public func cancelDashboardDeletion() {
        dashboardNameToDelete = nil
    }

    public func deleteRequestedWidget() {
        guard var currentDashboard, let widgetIDToDelete else { return }
        currentDashboard.widgetConfigs.removeAll(where: {
            $0.id == widgetIDToDelete
        })

        try? dashboardService.update(
            dashboardName: currentDashboard.name,
            dashboard: currentDashboard
        )
    }

    public func cancelWidgetDeletion() {
        widgetIDToDelete = nil
    }
}

extension DashboardViewModelImpl {

    public func didUpdateWidgetsOrder(_ widgets: [WidgetData]) {
        guard
            var currentDashboard = currentDashboard,
            currentDashboard.widgetConfigs.map({ $0.id }) != widgets.map({ $0.config.id })
        else { return }

        currentDashboard.widgetConfigs = widgets.map { $0.config }
        try? dashboardService.update(
            dashboardName: currentDashboard.name,
            dashboard: currentDashboard
        )
    }

    public func didUpdateDashboardsOrder(_ dashboards: [Dashboard]) {
        try? self.dashboardService.update(order: dashboards.map { $0.name })
    }
}

extension DashboardViewModelImpl {

    public func didClickAddDashboard() {
        delegate?.didSelectAddDashboard()
    }

    public func didClickRemove(dashboard: Dashboard) {
        dashboardNameToDelete = dashboard.name
        removeDashboardAlert = true
    }

    public func didClickEdit(dashboard: Dashboard) {
        delegate?.didSelectEditDashboard(dashboard)
        editModel = false
    }

    public func didClickRemove(widget: WidgetData) {
        widgetIDToDelete = widget.config.id
        removeWidgetAlert = true
    }

    public func didClickEdit(widget: WidgetData) {
        guard let currentDashboard else { return }
        delegate?.didSelectEditWidget(widget, currentDashboard)
        editModel = false
    }

    public func didClickConfig() {
        delegate?.didSelectConfig()
    }
}

extension DashboardViewModelImpl {

    public func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: lightEntity.id)
            } catch {
                setError(
                    message: Localizable.lightError.value,
                    logMessage: "Could not execute \(String(describing: service))"
                )
            }
        }
    }

    public func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State) {
        Task {
            let service: EntityActionService = newState == .on ? .turnOn : .turnOff
            do {
                try await entityService.execute(service: service, entityID: fanEntity.id)
            } catch {
                setError(
                    message: Localizable.lightError.value,
                    logMessage: "Could not execute \(String(describing: service))"
                )
            }
        }
    }
}
