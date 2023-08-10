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

public class DashboardEditViewModelImpl<DashboardS: DashboardService>: DashboardEditViewModel {

    public let mode: DashboardEditMode
    public var delegate: DashboardEditExternalFlow?

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

    public init(dashboardService: DashboardS, mode: DashboardEditMode) {
        self.dashboardService = dashboardService
        self.mode = mode

        setupData(mode)
        setupUIObservers()
    }
}

// MARK: - Setups Methods

extension DashboardEditViewModelImpl {

    private func setupData(_ mode: DashboardEditMode) {
        guard case .edit(let dashboard) = mode else { return }
        originalName = dashboard.name
        dashboardName = dashboard.name
        columnsNumber = dashboard.columns
        selectedIconName = icons.first(where: { $0.name == dashboard.icon })?.name
    }

    private func setupUIObservers() {
        // Update icon's list when the type a name
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardEditViewModelImpl {

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
        let name = dashboardName
        guard !name.isEmpty else {
            throw DashboardEditViewModelError.missingName
        }

        if name != originalName {
            guard dashboardService.dashboards.value[name] == nil else {
                throw DashboardEditViewModelError.nameAlreadyExists
            }
        }

        guard let selectedIconName else {
            throw DashboardEditViewModelError.missingIcon
        }

        guard columnsNumber > 0 else {
            throw DashboardEditViewModelError.invalidNumberOfColumns
        }

        return Dashboard(
            name: name,
            icon: selectedIconName,
            columns: columnsNumber,
            widgetConfigs: []
        )
    }
}

// MARK: - Interfaces

extension DashboardEditViewModelImpl {

    public func createOrUpdateDashboard() {
        do {
            let dashboard = try createDashboard()
            if mode == .creation {
                try dashboardService.add(dashboard: dashboard)
            } else {
                try dashboardService.update(dashboardName: originalName, dashboard: dashboard)
            }
            delegate?.didFinish()
        } catch let error as DashboardEditViewModelError {
            toastData = .init(type: .error, title: error.message)
            Logger.log(level: .error, error.localizedDescription)
        } catch {
            toastData = .init(type: .error, title: Localizable.unknownError.value)
            Logger.log(level: .error, error.localizedDescription)
        }
    }

    public func close() {
        delegate?.didClose()
    }
}
