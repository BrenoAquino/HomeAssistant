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

public class DashboardCreationViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = []
    private var allEntities: Entities = .init()
    let mode: DashboardCreationMode

    // MARK: External Actions

    public var didFinish: (() -> Void)?
    public var didClose: (() -> Void)?

    // MARK: Publishers

    @Published var dashboardName: String = ""
    @Published private(set) var icons: [IconUI] = IconUI.list
    @Published private(set) var selectedIconIndex: Int = .zero
    @Published var iconFilterText: String = ""
    @Published private(set) var entities: [EntityUI] = []
    @Published private(set) var selectedEntitiesIDs: Set<String> = []
    @Published var entityFilterText: String = ""
    @Published private(set) var domains: [EntityDomainUI] = []
    @Published private(set) var selectedDomains: Set<String> = []

    // MARK: Services

    private let dashboardService: DashboardService
    private let entitiesService: EntityService

    // MARK: Gets

    private var sortedEntities: [Entity] {
        Array(allEntities.all.values).sorted(by: { $0.name < $1.name })
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

// MARK: - Private Methods

extension DashboardCreationViewModel {

    private func setupData(_ mode: DashboardCreationMode) {
        guard case .edit(let dashboard) = mode else { return }

        dashboardName = dashboard.name
        selectedIconIndex = icons.firstIndex(where: { $0.name == dashboard.icon }) ?? .zero
        selectedEntitiesIDs = Set(dashboard.entities.map { $0.id })
    }

    private func setupObservers() {
        entitiesService
            .entities
            .sink { [weak self] in
                self?.allEntities = $0
            }
            .store(in: &cancellable)

        entitiesService
            .domains
            .sink { [weak self] domains in
                self?.domains = domains
                self?.selectedDomains = Set(domains.map { $0.name })
            }
            .store(in: &cancellable)

        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)

        $entityFilterText
            .sink { [weak self] in self?.filterEntity($0) }
            .store(in: &cancellable)
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

    private func filterEntity(_ text: String) {
        let allEntities = sortedEntities
        guard !text.isEmpty || !selectedDomains.isEmpty else {
            entities = allEntities
            return
        }

        let result = allEntities.filter { [weak self] entity in
            guard let self else { return false }
            let nameCheck = [entity.name, entity.domain.name].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            let domainCheck = self.selectedDomains.contains(entity.domain.name)
            return nameCheck && domainCheck
        }

        entities = result.isEmpty ? allEntities : result
    }
}

// MARK: - Interfaces

extension DashboardCreationViewModel {

    func selectIcon(_ icon: IconUI, index: Int) {
        guard index < icons.count && index >= 0 else { return }
        selectedIconIndex = index
    }

    func updateEntitySelection(_ entity: EntityUI, isSelected: Bool) {
        if isSelected {
            selectedEntitiesIDs.insert(entity.id)
        } else {
            selectedEntitiesIDs.remove(entity.id)
        }
    }

    func updateDomainSelection(_ domain: EntityDomainUI, isSelected: Bool) {
        if isSelected {
            selectedDomains.insert(domain.name)
        } else {
            selectedDomains.remove(domain.name)
        }

        filterEntity(entityFilterText)
    }

    func createDashboard() {
        let name = dashboardName
        guard !name.isEmpty else {
            Logger.log(level: .error, "Name must be filled")
            return
        }
        guard !dashboardService.dashboards.value.contains(where: { $0.name == name }) else {
            Logger.log(level: .error, "Name already in use")
            return
        }

        let icon = icons[selectedIconIndex].name
        guard !icon.isEmpty else {
            Logger.log(level: .error, "Icon required")
            return
        }

        let entities = Array(allEntities.all.values).filter { [weak self] entity in
            self?.selectedEntitiesIDs.contains(entity.id) == true
        }
        guard !entities.isEmpty else {
            Logger.log(level: .error, "It is necessary at least 1 device")
            return
        }

        let dashboard = Dashboard(name: name, icon: icon, entities: entities)
        do {
            try dashboardService.add(dashboard: dashboard)
            didFinish?()
        } catch {
            Logger.log(level: .error, error.localizedDescription)
        }
    }

    func close() {
        didClose?()
    }
}
