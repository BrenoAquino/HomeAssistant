//
//  EntitySelectionViewModelImpl.swift
//
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import Combine
import Common
import Domain
import Foundation

class EntitySelectionViewModelImpl<EntityS: EntityService>: EntitySelectionViewModel {

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Services

    private var entityService: EntityS

    // MARK: Publishers

    @Published private(set) var entities: [AnyEntity] = []
    @Published var entityFilterText: String = ""
    @Published var selectedDomainsNames: Set<String> = []

    // MARK: Gets

    var domains: [Domain.EntityDomain] {
        entityService.domains.value
    }

    // MARK: Init

    init(entityService: EntityS) {
        self.entityService = entityService

        setupServiceObservers()
        setupUIObservers()
    }
}

// MARK: - Setups

extension EntitySelectionViewModelImpl {

    private func setupData(_ mode: WidgetEditMode) {
        selectedDomainsNames = Set(domains.map { $0.rawValue })
    }

    private func setupServiceObservers() {
        // Update the entities list if changed
        entityService
            .entities
            .receive(on: RunLoop.main)
            .sink { [weak self] entities in
                guard let self else { return }
                self.filterEntity(
                    self.entityFilterText,
                    self.selectedDomainsNames,
                    entities,
                    self.entityService.hiddenEntityIDs.value
                )
            }
            .store(in: &cancellable)

        // Update the entities list if the value of hidden entities has changed
        entityService
            .hiddenEntityIDs
            .receive(on: RunLoop.main)
            .sink { [weak self] hiddenEntityIDs in
                guard let self else { return }
                self.filterEntity(
                    self.entityFilterText,
                    self.selectedDomainsNames,
                    self.entityService.entities.value,
                    hiddenEntityIDs
                )
            }
            .store(in: &cancellable)
    }

    private func setupUIObservers() {
        // Update entities' list when the user filter for a name or for a domain
        Publishers
            .CombineLatest($entityFilterText, $selectedDomainsNames)
            .receive(on: RunLoop.main)
            .sink { [weak self] text, selectedDomains in
                guard let self else { return }
                self.filterEntity(
                    text,
                    selectedDomains,
                    self.entityService.entities.value,
                    self.entityService.hiddenEntityIDs.value
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension EntitySelectionViewModelImpl {

    private func filterEntity(
        _ text: String,
        _ domainNames: Set<String>,
        _ entities: [String : any Entity],
        _ hiddenEntityIDs: Set<String>
    ) {
        let allEntities = Array(entities.values)
            .filter { !hiddenEntityIDs.contains($0.id) }
            .sorted(by: { $0.name < $1.name })
            .map { AnyEntity(entity: $0) }

        guard !text.isEmpty || !domainNames.isEmpty else {
            self.entities = allEntities
            return
        }

        let result = allEntities.filter { entity in
            let nameCheck = [
                entity.entity.name,
                entity.entity.domain.rawValue
            ].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            let domainCheck = domainNames.contains(entity.entity.domain.rawValue)
            return nameCheck && domainCheck
        }
        self.entities = result.isEmpty ? allEntities : result
    }
}

// MARK: - Public Methods

extension EntitySelectionViewModelImpl {

    func didSelectEntity(_ entity: any Entity) {}
    func close() {}
}
