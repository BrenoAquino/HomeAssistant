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

enum DashboardCreationViewModelStates {
    case loading
    case content
    case finish
}

public class DashboardCreationViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Publishers

    @Published private(set) var state: DashboardCreationViewModelStates = .loading
    @Published var dashboardName: String = ""
    @Published private(set) var icons: [IconUI] = []
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

    private var entitiesHandler: Entities { entitiesService.entities }

    // MARK: Init

    public init(dashboardService: DashboardService, entitiesService: EntityService) {
        self.dashboardService = dashboardService
        self.entitiesService = entitiesService

        setupObservers()
        setupData()
    }
}

// MARK: - Private Methods

extension DashboardCreationViewModel {

    private func setupObservers() {
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)

        $entityFilterText
            .sink { [weak self] in self?.filterEntity($0) }
            .store(in: &cancellable)
    }

    private func setupData() {
        icons = IconUI.list
        entities = Array(entitiesHandler.all.values)
        domains = entitiesService.domains
        selectedDomains = Set(domains.map { $0.name })
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
        let allEntities = Array(entitiesHandler.all.values)
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
}
