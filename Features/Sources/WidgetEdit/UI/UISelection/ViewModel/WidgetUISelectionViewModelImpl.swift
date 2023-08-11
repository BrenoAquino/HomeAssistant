//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import Domain
import Foundation
import Combine

class WidgetUISelectionViewModelImpl<DashboardS: DashboardService>: WidgetUISelectionViewModel {

    var delegate: WidgetUISelectionExternalFlow?
    let dashboard: Dashboard
    let entity: any Entity
    let widgetConfig: WidgetConfig?
    let viewIDs: [String]

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Services

    private let dashboardService: DashboardS

    // MARK: Publishers

    @Published private(set) var widgetCustomInfo: WidgetCustomInfo
    @Published var widgetTitle: String
    @Published var selectedViewID: String
    @Published var toastData: DefaultToastDataContent?

    // MARK: Gets

    var doesWidgetAlreadyExist: Bool { widgetConfig != nil }

    // MARK: Init

    init(
        dashboardService: DashboardS,
        dashboard: Dashboard,
        widgetData: WidgetData
    ) {
        self.dashboardService = dashboardService
        self.dashboard = dashboard

        entity = widgetData.entity
        widgetConfig = widgetData.config
        widgetCustomInfo = widgetData.config.customInfo
        widgetTitle = widgetData.config.customInfo.title
        selectedViewID = widgetData.config.uiType

        switch entity.domain {
        case .light:
            viewIDs = WidgetViewList.light.map { $0.uniqueID }
        case .fan:
            viewIDs = WidgetViewList.fan.map { $0.uniqueID }
        case .climate, .switch:
            viewIDs = []
        }

        setupUIObservers()
    }

    init(
        dashboardService: DashboardS,
        dashboard: Dashboard,
        entity: any Entity
    ) {
        self.dashboardService = dashboardService
        self.dashboard = dashboard

        self.entity = entity
        widgetConfig = nil
        widgetCustomInfo = WidgetCustomInfo(title: entity.name)
        widgetTitle = entity.name
        selectedViewID = "default"

        switch entity.domain {
        case .light:
            viewIDs = WidgetViewList.light.map { $0.uniqueID }
        case .fan:
            viewIDs = WidgetViewList.fan.map { $0.uniqueID }
        case .climate, .switch:
            viewIDs = []
        }

        setupUIObservers()
    }
}

// MARK: - Setups

extension WidgetUISelectionViewModelImpl {

    private func setupUIObservers() {
        // Generate a new custom info
        $widgetTitle
            .sink { [weak self] in self?.widgetCustomInfo.title = $0 }
            .store(in: &cancellable)
    }
}

// MARK: - Methods

extension WidgetUISelectionViewModelImpl {

    func createOrUpdateWidget() {
        do {
            // Get index if exists
            var indexToReplace: Int?
            if let widgetConfig = widgetConfig {
                indexToReplace = dashboard.widgetConfigs.firstIndex(of: widgetConfig)
            }

            // Create the new widget
            let widgetConfig = WidgetConfig(
                id: widgetConfig?.id ?? UUID().uuidString,
                entityID: entity.id,
                uiType: selectedViewID,
                customInfo: widgetCustomInfo
            )

            // Update/Create
            var dashboard = self.dashboard
            if let indexToReplace {
                dashboard.widgetConfigs[indexToReplace] = widgetConfig
            } else {
                dashboard.widgetConfigs.append(widgetConfig)
            }
            try dashboardService.update(
                dashboardName: dashboard.name,
                dashboard: dashboard
            )
            delegate?.didClose()
            
        } catch {
            toastData = .init(type: .error, title: Localizable.unknownError.value)
            Logger.log(level: .error, error.localizedDescription)
        }
    }
}
