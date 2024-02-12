//
//  ConfigViewModelImpl.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import Foundation
import Combine
import SwiftUI

public class ConfigViewModelImpl<EntityS: EntityService>: ConfigViewModel {
    // MARK: Private Variables

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Services

    private var entityService: EntityS

    // MARK: Publishers

    @Published public var entityFilterText: String = ""
    @Published public var entities: [any Entity] = []

    // MARK: Gets

    public var hiddenEntityIDs: Set<String> {
        get { entityService.hiddenEntityIDs }
        set { entityService.update(hiddenEntityIDs: newValue) }
    }

    // MARK: Init

    public init(entityService: EntityS) {
        self.entityService = entityService

        setupData()
        setupServiceObservers()
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension ConfigViewModelImpl {

    private func setupData() {
        entities = Array(entityService.entities.values).sorted(by: { $0.name < $1.name })
    }

    private func setupServiceObservers() {
        entityService
            .entitiesPublisher
            .sink { [weak self] entities in
                guard let self else { return }
                self.updateEntities(
                    entities,
                    self.entityFilterText
                )
            }
            .store(in: &cancellable)
    }

    private func setupUIObservers() {
        $entityFilterText
            .sink { [weak self] text in
                guard let self else { return }
                self.updateEntities(
                    self.entityService.entities,
                    text
                )
            }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension ConfigViewModelImpl {

    private func updateEntities(_ entities: [String : any Entity], _ text: String) {
        let allEntities = Array(entities.values).sorted(by: { $0.name < $1.name })
        guard !text.isEmpty else {
            self.entities = allEntities
            return
        }
        let result = allEntities.filter { entity in
            [
                entity.name,
                entity.domain.name
            ].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
        }
        self.entities = result.isEmpty ? allEntities : result
    }
}

// MARK: - Public Methods

extension ConfigViewModelImpl {
    public func addEntityOnHiddenList(_ id: String) {
        hiddenEntityIDs.insert(id)
    }

    public func removeEntityFromHiddenList(_ id: String) {
        hiddenEntityIDs.remove(id)
    }
}
