//
//  DashboardCreationViewModel.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import Combine
import Common
import Domain
import Foundation
import SwiftUI

public class DashboardCreationViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardCreationViewModel {

    public let mode: DashboardCreationMode
    public weak var delegate: DashboardCreationExternalFlow?

    // MARK: Private Variables

    private var cancellable: Set<AnyCancellable> = []
    private var originalName: String = ""

    // MARK: Publishers

    @Published public var dashboardName: String = ""

    @Published public private(set) var icons: [Icon] = Icon.list
    @Published public var selectedIconName: String?
    @Published public var iconFilterText: String = ""

    @Published public var entities: [any Entity] = []
    @Published public var selectedEntitiesIDs: Set<String> = []
    @Published public var entityFilterText: String = ""

    @Published public var selectedDomainsNames: Set<String> = []

    // MARK: Services

    private var dashboardService: DashboardS
    @ObservedObject private var entitiesService: EntityS

    // MARK: Gets

    public var domains: [EntityDomain] {
        entitiesService.domains
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entitiesService: EntityS, mode: DashboardCreationMode) {
        self.dashboardService = dashboardService
        self.entitiesService = entitiesService
        self.mode = mode

        setupData(mode)
        setupObservers()
    }
}

// MARK: - Setups

extension DashboardCreationViewModelImpl {

    private func setupData(_ mode: DashboardCreationMode) {
        selectedDomainsNames = Set(entitiesService.domains.map { $0.rawValue })

        guard case .edit(let dashboard) = mode else { return }
        originalName = dashboard.name
        dashboardName = dashboard.name
        selectedIconName = icons.first(where: { $0.name == dashboard.icon })?.name
        selectedEntitiesIDs = Set(dashboard.entitiesIDs)
    }

    private func setupObservers() {
        serviceObservers()
        uiObservers()
    }

    private func serviceObservers() {
        entitiesService.forward(objectWillChange, on: RunLoop.main).store(in: &cancellable)
        dashboardService.forward(objectWillChange, on: RunLoop.main).store(in: &cancellable)
    }

    private func uiObservers() {
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)

        Publishers
            .CombineLatest($entityFilterText, $selectedDomainsNames)
            .sink { [weak self] in self?.filterEntity($0, domainNames: $1) }
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

    private func filterEntity(_ text: String, domainNames: Set<String>) {
        let allEntities = Array(entitiesService.entities.values).sorted(by: { $0.name < $1.name })
        guard !text.isEmpty || !domainNames.isEmpty else {
            entities = allEntities
            return
        }
        let result = allEntities.filter { entity in
            let nameCheck = [entity.name, entity.domain.rawValue].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            let domainCheck = domainNames.contains(entity.domain.rawValue)
            return nameCheck && domainCheck
        }
        entities = result.isEmpty ? allEntities : result
    }

    private func createDashboard() throws -> Dashboard {
        let name = dashboardName
        guard !name.isEmpty else {
            throw DashboardCreationViewModelError.missingName
        }

        if name != originalName {
            guard !dashboardService.dashboards.contains(where: { $0.name == name }) else {
                throw DashboardCreationViewModelError.nameAlreadyExists
            }
        }

        guard let selectedIconName else {
            throw DashboardCreationViewModelError.missingIcon
        }

        guard !selectedEntitiesIDs.isEmpty else {
            throw DashboardCreationViewModelError.missingEntities
        }

        return Dashboard(name: name, icon: selectedIconName, entities: Array(selectedEntitiesIDs))
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
        } catch {
            Logger.log(level: .error, error.localizedDescription)
        }
    }

    public func close() {
        delegate?.didClose()
    }
}
