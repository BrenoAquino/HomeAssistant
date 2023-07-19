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
    @Published private(set) var selectedEntities: Set<Int> = []
    @Published private(set) var domains: [EntityDomainUI] = []
    @Published private(set) var selectedDomains: Set<Int> = []

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
    }

    private func setupData() {
        icons = IconUI.list
        entities = Array(entitiesHandler.all.values)
        domains = entitiesService.domains
        selectedDomains = Set(0 ..< entitiesService.domains.count)
    }

    private func filterIcon(_ text: String) {
        guard !text.isEmpty else {
            icons = IconUI.list
            return
        }

        let result = IconUI.list.filter { icon in
            let strings = [icon.name].appended(contentsOf: icon.keywords)
            for string in strings {
                guard text.count <= string.count else { continue }
                let startIndex = string.startIndex
                let endIndex = string.index(startIndex, offsetBy: text.count)
                let range = Range(uncheckedBounds: (startIndex, endIndex))
                if string.compare(text, options: [.caseInsensitive, .diacriticInsensitive], range: range) == .orderedSame {
                    return true
                }
            }
            return false
        }
        
        icons = result.isEmpty ? IconUI.list : result
    }
}

// MARK: - Interfaces

extension DashboardCreationViewModel {

    func selectIcon(_ icon: IconUI, index: Int) {
        guard index < icons.count && index >= 0 else { return }
        selectedIconIndex = index
    }

    func updateEntitySelection(_ entity: EntityUI, index: Int, isSelected: Bool) {
        if isSelected {
            selectedEntities.insert(index)
        } else {
            selectedEntities.remove(index)
        }
    }

    func updateDomainSelection(_ domain: EntityDomainUI, index: Int, isSelected: Bool) {
        if isSelected {
            selectedDomains.insert(index)
        } else {
            selectedDomains.remove(index)
        }
    }
}
