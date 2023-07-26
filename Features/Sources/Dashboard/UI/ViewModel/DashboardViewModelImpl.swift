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

    // MARK: Services

    private var entityService: EntityS
    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var removeAlert: Bool = false
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

        // Update the entity state if it one of the current ones has changed
        entityService
            .entityStateChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] entity in
                guard let entityIndex = self?.entities.firstIndex(where: { $0.id == entity.id }) else {
                    return
                }
                self?.entities[entityIndex] = entity
            }
            .store(in: &cancellable)

        // Update the dashboard when we get any change on it
        dashboardService
            .dashboards
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

        // Update to use the new order
        $dashboards
            .sink { [weak self] dashboards in
                guard let self else { return }
                do {
                    try self.dashboardService.update(order: dashboards.map { $0.name })
                } catch {
                    self.toastData = .init(type: .error, title: Localizable.reorderError.value)
                    Logger.log(level: .error, "Could not reorder")
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardViewModelImpl {

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
        dashboards.removeAll(where: { $0.name == dashboardNameToDelete })
        toastData = .init(type: .success, title: Localizable.deleteSuccess.value)
    }

    public func cancelDashboardDeletion() {
        dashboardNameToDelete = nil
    }

    public func didClickAdd() {
        delegate?.didSelectAddDashboard()
    }

    public func didClickRemove(_ dashboard: Dashboard) {
        dashboardNameToDelete = dashboard.name
        removeAlert = true
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
                toastData = .init(type: .error, title: Localizable.lightError.value)
                Logger.log(level: .error, "Could not execute \(String(describing: service))")
            }
        }
    }
}
