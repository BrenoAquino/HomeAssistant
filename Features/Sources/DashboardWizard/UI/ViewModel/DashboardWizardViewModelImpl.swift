//
//  DashboardEditViewModel.swift
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

public class DashboardWizardViewModelImpl<DashboardS: DashboardService>: DashboardWizardViewModel {
    public var externalFlows: DashboardWizardExternalFlow?
    public let mode: DashboardWizardMode
    private var cancellable: Set<AnyCancellable> = []
    private var originalName: String = ""

    // MARK: Services

    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var toastData: DefaultToastDataContent?
    @Published public private(set) var icons: [Icon] = Icon.list
    @Published public var iconFilterText: String = ""
    @Published public var dashboardName: String = ""
    @Published public var selectedIconName: String?
    @Published public var columnsNumber: Int = 3

    // MARK: Init

    public init(dashboardService: DashboardS, mode: DashboardWizardMode) {
        self.dashboardService = dashboardService
        self.mode = mode

        setupData(mode)
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension DashboardWizardViewModelImpl {
    private func setupData(_ mode: DashboardWizardMode) {
        guard case .edit(let dashboard) = mode else { return }
        originalName = dashboard.name
        dashboardName = dashboard.name
        columnsNumber = dashboard.columns
        selectedIconName = icons.first(where: { $0.name == dashboard.icon })?.name
    }

    private func setupUIObservers() {
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardWizardViewModelImpl {
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

    private func createDashboard() throws -> Dashboard {
        guard !dashboardName.isEmpty else {
            throw DashboardWizardViewModelError.missingName
        }

        if dashboardName != originalName {
            guard dashboardService.dashboards[dashboardName] == nil else {
                throw DashboardWizardViewModelError.nameAlreadyExists
            }
        }

        guard let selectedIconName else {
            throw DashboardWizardViewModelError.missingIcon
        }

        guard columnsNumber > 0 else {
            throw DashboardWizardViewModelError.invalidNumberOfColumns
        }

        return Dashboard(
            name: dashboardName,
            icon: selectedIconName,
            columns: columnsNumber,
            widgetConfigs: []
        )
    }
}

// MARK: - Interfaces

extension DashboardWizardViewModelImpl {
    public func createOrUpdateDashboard() {
        do {
            let dashboard = try createDashboard()
            if mode == .creation {
                try dashboardService.add(dashboard: dashboard)
            } else {
                try dashboardService.update(dashboardName: originalName, dashboard: dashboard)
            }
            externalFlows?.didFinish()
        } catch let error as DashboardWizardViewModelError {
            toastData = .init(type: .error, title: error.message)
        } catch {
            toastData = .init(type: .error, title: Localizable.unknownError.value)
        }
    }

    public func close() {
        externalFlows?.didClose()
    }
}
