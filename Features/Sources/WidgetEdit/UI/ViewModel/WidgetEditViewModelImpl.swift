//
//  WidgetEditViewModelImpl.swift
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

public class WidgetEditViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: WidgetEditViewModel {

    public var delegate: WidgetEditExternalFlow?
    public private(set) var mode: WidgetEditMode

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Services

    private var dashboardService: DashboardS
    private var entityService: EntityS

    // MARK: Publishers

    @Published public var toastData: DefaultToastDataContent?
    @Published public var currentStep: WidgetEditStep
    @Published private(set) public var entities: [any Entity] = []
    @Published public var entityFilterText: String = ""
    @Published public var selectedDomainsNames: Set<String> = []

    // MARK: Gets

    public var domains: [Domain.EntityDomain] {
        entityService.domains.value
    }

    public var isFirstStep: Bool {
        switch mode {
        case .creation:
            return currentStep == .entitySelection
        case .edit:
            return currentStep == .uiSelection
        }
    }

    public var isLastStep: Bool {
        currentStep == .uiSelection
    }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS, dashboard: Dashboard, mode: WidgetEditMode) {
        self.dashboardService = dashboardService
        self.entityService = entityService
        self.mode = mode
        currentStep = mode == .creation ? .entitySelection : .uiSelection

        setupData(mode)
        setupServiceObservers()
    }
}

// MARK: - Setups

extension WidgetEditViewModelImpl {

    private func setupData(_ mode: WidgetEditMode) {
        selectedDomainsNames = Set(domains.map { $0.rawValue })
    }

    private func setupServiceObservers() {
        // Update the entities list if changed
        entityService
            .entities
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
}

// MARK: - Private Methods

extension WidgetEditViewModelImpl {

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

        DispatchQueue.main.async {
            self.entities = result.isEmpty ? allEntities : result
        }
    }

    private func setError(
        message: String,
        logMessage: String? = nil
    ) {
        toastData = .init(type: .error, title: message)
        Logger.log(level: .error, logMessage ?? message)
    }
}

// MARK: - Public Methods

extension WidgetEditViewModelImpl {

    public func didSelectEntity(_ entity: any Entity) {

    }

    public func nextStep() {
        guard let next = currentStep.next else { return }
        currentStep = next
    }

    public func previousStep() {
        guard let previous = currentStep.previous else { return }
        currentStep = previous
    }

    public func createOrUpdateWidget() {

    }

    public func close() {
        delegate?.didClose()
    }
}
