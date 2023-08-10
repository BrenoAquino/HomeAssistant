//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import Domain
import Foundation

class WidgetUISelectionViewModelImpl<DashboardS: DashboardService>: WidgetUISelectionViewModel {

    var delegate: WidgetUISelectionExternalFlow?
    let dashboard: Dashboard
    let entity: any Entity
    let widgetConfig: WidgetConfig?
    let viewIDs: [String]

    // MARK: Services

    private let dashboardService: DashboardS

    // MARK: Publishers

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
        widgetTitle = widgetData.config.title
        selectedViewID = widgetData.config.uiType

        switch entity.domain {
        case .light:
            viewIDs = WidgetViewList.light.map { $0.uniqueID }
        case .fan:
            viewIDs = WidgetViewList.fan.map { $0.uniqueID }
        case .climate, .switch:
            viewIDs = []
        }
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
    }
}

// MARK: - Methods

extension WidgetUISelectionViewModelImpl {

    func createOrUpdateWidget() {
        do {
            var dashboard = self.dashboard
            if let id = widgetConfig?.id {
                dashboard.widgetConfigs.removeAll(where: { $0.id == id })
            }
            dashboard.widgetConfigs.append(WidgetConfig(
                id: widgetConfig?.id ?? UUID().uuidString,
                entityID: entity.id,
                title: widgetTitle,
                uiType: selectedViewID
            ))
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
