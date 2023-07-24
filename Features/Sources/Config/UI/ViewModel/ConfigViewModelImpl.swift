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

    public var delegate: ConfigExternalFlow?

    // MARK: Private Variables

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Services

    @ObservedObject private var entityService: EntityS

    // MARK: Publishers

    @Published public var entityFilterText: String = ""
    @Published public var entities: [any Entity] = []

    // MARK: Gets

    public var hiddenEntityIDs: Set<String> {
        get { entityService.hiddenEntities }
        set { entityService.hiddenEntities = newValue }
    }

    // MARK: Init

    public init(entityService: EntityS) {
        self.entityService = entityService

        setupData()
        setupForwards()
        setupUIObservers()
    }
}

// MARK: - Private Methods

extension ConfigViewModelImpl {

    private func setupData() {
        entities = Array(entityService.entities.values).sorted(by: { $0.name < $1.name })
    }

    private func setupForwards() {
        entityService.forward(objectWillChange, on: RunLoop.main).store(in: &cancellable)
    }

    private func setupUIObservers() {
        $entityFilterText
            .sink { [weak self] in self?.filterEntity($0) }
            .store(in: &cancellable)
    }

    private func filterEntity(_ text: String) {
        let allEntities = Array(entityService.entities.values).sorted(by: { $0.name < $1.name })
        guard !text.isEmpty else {
            entities = allEntities
            return
        }
        let result = allEntities.filter { entity in
            let nameCheck = [entity.name, entity.domain.rawValue].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
            return nameCheck
        }
        entities = result.isEmpty ? allEntities : result
    }
}

// MARK: - Public Methods

extension ConfigViewModelImpl {

    public func close() {
        delegate?.didClose()
    }
}
