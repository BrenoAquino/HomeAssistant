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

public enum DashboardCreationMode: Equatable {
    case creation
    case edit(_ dashboard: Dashboard)
}

enum DashboardCreationViewModelError: Error {
    case missingName
    case nameAlreadyExists
    case missingIcon
    case missingEntities
}

public class DashboardCreationViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = []
    private var allEntities: [String : any Entity] = [:]
    private var originalName: String = ""
    let mode: DashboardCreationMode

    // MARK: External Actions

    public var didFinish: (() -> Void)?
    public var didClose: (() -> Void)?

    // MARK: Publishers

    @Published var dashboardName: String = ""

    @Published private(set) var icons: [IconUI] = IconUI.list
    @Published var selectedIcon: IconUI?
    @Published var iconFilterText: String = ""

    @Published private(set) var entities: [EntityUI] = []
    @Published var selectedEntitiesIDs: Set<String> = []
    @Published var entityFilterText: String = ""

    @Published private(set) var domains: [EntityDomainUI] = []
    @Published var selectedDomainsNames: Set<String> = []

    // MARK: Services

    private let dashboardService: DashboardService
    private let entitiesService: EntityService

    // MARK: Gets

    private var sortedEntities: [any Entity] {
        Array(allEntities.values).sorted(by: { $0.name < $1.name })
    }

    // MARK: Init

    public init(dashboardService: DashboardService, entitiesService: EntityService, mode: DashboardCreationMode) {
        self.dashboardService = dashboardService
        self.entitiesService = entitiesService
        self.mode = mode

        setupData(mode)
        setupObservers()
    }
}

// MARK: - Setups

extension DashboardCreationViewModel {

    private func setupObservers() {
        serviceObservers()
        uiObservers()
    }

    private func serviceObservers() {
        entitiesService
            .entities
            .sink { [weak self] in self?.allEntities = $0 }
            .store(in: &cancellable)

        entitiesService
            .domains
            .sink { [weak self] domains in
                self?.domains = domains
                self?.selectedDomainsNames = Set(domains.map { $0.name })
            }
            .store(in: &cancellable)
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

extension DashboardCreationViewModel {

    private func setupData(_ mode: DashboardCreationMode) {
        guard case .edit(let dashboard) = mode else { return }

        originalName = dashboard.name
        dashboardName = dashboard.name
        selectedIcon = icons.first(where: { $0.name == dashboard.icon })
        selectedEntitiesIDs = Set(dashboard.entitiesIDs)
    }

    private func filterIcon(_ text: String) {
        guard !text.isEmpty else {
            icons = IconUI.list
            return
        }
        let result = IconUI.list.filter { icon in
            [icon.name].appended(contentsOf: icon.keywords).contains(text, options: [.caseInsensitive, .diacriticInsensitive])
        }
        icons = result.isEmpty ? IconUI.list : result
    }

    private func filterEntity(_ text: String, domainNames: Set<String>) {
        let allEntities = sortedEntities.map { $0.toUI() }
        guard !text.isEmpty || !domainNames.isEmpty else {
            entities = allEntities
            return
        }
        let result = allEntities.filter { entity in
            let nameCheck = [entity.name, entity.domainUI.name].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            let domainCheck = domainNames.contains(entity.domainUI.name)
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
            guard !dashboardService.dashboards.value.contains(where: { $0.name == name }) else {
                throw DashboardCreationViewModelError.nameAlreadyExists
            }
        }

        guard let selectedIcon else {
            throw DashboardCreationViewModelError.missingIcon
        }

        guard !selectedEntitiesIDs.isEmpty else {
            throw DashboardCreationViewModelError.missingEntities
        }

        return Dashboard(name: name, icon: selectedIcon.name, entities: Array(selectedEntitiesIDs))
    }
}

// MARK: - Interfaces

extension DashboardCreationViewModel {

    func createOrUpdateDashboard() {
        do {
            let dashboard = try createDashboard()
            if mode == .creation {
                try dashboardService.add(dashboard: dashboard)
            } else {
                try dashboardService.update(dashboardName: originalName, dashboard: dashboard)
            }
            didFinish?()
        } catch {
            Logger.log(level: .error, error.localizedDescription)
        }
    }

    func close() {
        didClose?()
    }
}
