//
//  DashboardCreationViewModel.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import Combine
import Common
import Domain
import Foundation
import SwiftUI

public class DashboardCreationViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardCreationViewModel {

    public let mode: DashboardCreationMode
    public var delegate: DashboardCreationExternalFlow?

    private var cancellable: Set<AnyCancellable> = []
    private var originalName: String = ""

    // MARK: Services

    private var dashboardService: DashboardS
    private var entitiesService: EntityS

    // MARK: Publishers

    @Published public var toastData: DefaultToastDataContent?
    @Published public var dashboardName: String = ""
    @Published public private(set) var icons: [Icon] = Icon.list
    @Published public var selectedIconName: String?
    @Published public var iconFilterText: String = ""
    @Published public var entities: [any Entity] = []
    @Published public var selectedEntitiesIDs: Set<String> = []
    @Published public var entityFilterText: String = ""
    @Published public var selectedDomainsNames: Set<String> = []

    // MARK: Gets

    public var domains: [EntityDomain] {
        entitiesService.domains.value
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entitiesService: EntityS, mode: DashboardCreationMode) {
        self.dashboardService = dashboardService
        self.entitiesService = entitiesService
        self.mode = mode

        setupData(mode)
        setupServiceObservers()
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension DashboardCreationViewModelImpl {

    private func setupData(_ mode: DashboardCreationMode) {
        selectedDomainsNames = Set(entitiesService.domains.value.map { $0.rawValue })

        guard case .edit(let dashboard) = mode else { return }
        originalName = dashboard.name
        dashboardName = dashboard.name
        selectedIconName = icons.first(where: { $0.name == dashboard.icon })?.name
        selectedEntitiesIDs = Set(dashboard.widgets.map { $0.entityID })
    }

    private func setupServiceObservers() {
        // Update the entities list if changed
        entitiesService
            .entities
            .sink { [weak self] entities in
                guard let self else { return }
                self.filterEntity(
                    self.entityFilterText,
                    self.selectedDomainsNames,
                    entities,
                    self.entitiesService.hiddenEntityIDs.value
                )
            }
            .store(in: &cancellable)

        // Update the entities list if the value of hidden entities has changed
        entitiesService
            .hiddenEntityIDs
            .sink { [weak self] hiddenEntityIDs in
                guard let self else { return }
                self.filterEntity(
                    self.entityFilterText,
                    self.selectedDomainsNames,
                    self.entitiesService.entities.value,
                    hiddenEntityIDs
                )
            }
            .store(in: &cancellable)
    }

    private func setupUIObservers() {
        // Update icon's list when the type a name
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)

        // Update entities' list when the user filter for a name or for a domain
        Publishers
            .CombineLatest($entityFilterText, $selectedDomainsNames)
            .sink { [weak self] text, selectedDomains in
                guard let self else { return }
                self.filterEntity(
                    text,
                    selectedDomains,
                    self.entitiesService.entities.value,
                    self.entitiesService.hiddenEntityIDs.value
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardCreationViewModelImpl {

    private func filterIcon(_ text: String) {
        guard !text.isEmpty else {
            icons = Icon.list
            return
        }
        let result = Icon.list.filter { icon in
            [icon.name].appended(contentsOf: icon.keywords).contains(text, options: [.caseInsensitive, .diacriticInsensitive])
        }
        icons = result.isEmpty ? Icon.list : result
    }

    private func filterEntity(
        _ text: String,
        _ domainNames: Set<String>,
        _ entities: [String : any Entity],
        _ hiddenEntityIDs: Set<String>
    ) {
        let allEntities = Array(entities.values)
            .filter { !hiddenEntityIDs.contains($0.id) }
            .sorted(by: { $0.name < $1.name })

        guard !text.isEmpty || !domainNames.isEmpty else {
            self.entities = allEntities
            return
        }

        let result = allEntities.filter { entity in
            let nameCheck = [entity.name, entity.domain.rawValue].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            let domainCheck = domainNames.contains(entity.domain.rawValue)
            return nameCheck && domainCheck
        }
        self.entities = result.isEmpty ? allEntities : result
    }

    private func createDashboard() throws -> Dashboard {
        let name = dashboardName
        guard !name.isEmpty else {
            throw DashboardCreationViewModelError.missingName
        }

        if name != originalName {
            guard dashboardService.dashboards.value[name] == nil else {
                throw DashboardCreationViewModelError.nameAlreadyExists
            }
        }

        guard let selectedIconName else {
            throw DashboardCreationViewModelError.missingIcon
        }

        guard !selectedEntitiesIDs.isEmpty else {
            throw DashboardCreationViewModelError.missingEntities
        }

        return Dashboard(
            name: name,
            icon: selectedIconName,
            widgets: selectedEntitiesIDs.map { EntityWidget(entityID: $0, uiType: "") }
        )
    }
}

// MARK: - Interfaces

extension DashboardCreationViewModelImpl {

    public func createOrUpdateDashboard() {
        do {
            let dashboard = try createDashboard()
            if mode == .creation {
                try dashboardService.add(dashboard: dashboard)
            } else {
                try dashboardService.update(dashboardName: originalName, dashboard: dashboard)
            }
            delegate?.didFinish()
        } catch let error as DashboardCreationViewModelError {
            toastData = .init(type: .error, title: error.message)
            Logger.log(level: .error, error.localizedDescription)
        } catch {
            toastData = .init(type: .error, title: Localizable.unknownError.value)
            Logger.log(level: .error, error.localizedDescription)
        }
    }

    public func close() {
        delegate?.didClose()
    }
}
