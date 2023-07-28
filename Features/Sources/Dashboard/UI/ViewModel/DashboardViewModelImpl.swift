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
    private var entityIDToDelete: String?

    // MARK: Services

    private var entityService: EntityS
    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var removeDashboardAlert: Bool = false
    @Published public var removeEntityAlert: Bool = false
    @Published public var editModel: Bool = false
    @Published public var toastData: DefaultToastDataContent?
    @Published public var selectedDashboardName: String?
    @Published public var entities: [any Entity] = []
    @Published public var dashboards: [Dashboard] = []

    // MARK: Gets

    public var currentDashboard: Dashboard? {
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
                self.setEntities(
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
                self.setEntities(
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
                self.setEntities(
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
            } else if let entitiesIDs = dict[element.name]?.entitiesIDs, Set(entitiesIDs) != Set(element.entitiesIDs) {
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

    private func setEntities(
        _ entities: [String : any Entity],
        _ dashboards: [String : Dashboard],
        _ dashboardName: String?
    ) {
        guard let dashboardName else {
            self.entities = []
            return
        }
        self.entities = dashboards[dashboardName]?.entitiesIDs.compactMap {
            entities[$0]
        } ?? []
    }
}

// MARK: - Public Methods

extension DashboardViewModelImpl {

    public func deleteRequestedDashboard() {
        guard let dashboardNameToDelete else { return }
        try? dashboardService.delete(dashboardName: dashboardNameToDelete)
        toastData = .init(type: .success, title: Localizable.deleteSuccess.value)
    }

    public func cancelDashboardDeletion() {
        dashboardNameToDelete = nil
    }

    public func deleteRequestedEntity() {
        guard var currentDashboard, let entityIDToDelete else { return }
        currentDashboard.entitiesIDs.removeAll(where: { $0 == entityIDToDelete })
        try? dashboardService.update(
            dashboardName: currentDashboard.name,
            dashboard: currentDashboard
        )
    }

    public func cancelEntityDeletion() {
        entityIDToDelete = nil
    }
}

extension DashboardViewModelImpl {

    public func didUpdateEntitiesOrder(_ entities: [any Entity]) {
        let ids = entities.map { $0.id }
        guard var currentDashboard = currentDashboard, currentDashboard.entitiesIDs != ids else { return }

        currentDashboard.entitiesIDs = ids
        try! dashboardService.update(
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

    public func didClickRemove(entity: any Entity) {
        entityIDToDelete = entity.id
        removeEntityAlert = true
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
