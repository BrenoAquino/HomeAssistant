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

public class WidgetEditViewModelImpl<DashboardS: DashboardService>: WidgetEditViewModel {

    private var dashboard: Dashboard

    public var delegate: WidgetEditExternalFlow?
    private var widgetData: WidgetData
    public private(set) var viewIDs: [String]

    // MARK: Services

    private var dashboardService: DashboardS

    // MARK: Publishers

    @Published public var widgetTitle: String
    @Published public var selectedViewID: String
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Gets

    public var entity: any Entity { widgetData.entity }
    public var widgetConfig: WidgetConfig { widgetData.config }

    // MARK: Init

    public init(dashboardService: DashboardS, dashboard: Dashboard, widgetData: WidgetData) {
        self.dashboardService = dashboardService
        self.dashboard = dashboard
        self.widgetData = widgetData

        widgetTitle = widgetData.entity.name
        selectedViewID = widgetData.config.uiType

        switch widgetData.entity.domain {
        case .light:
            viewIDs = WidgetViewList.light.map { $0.uniqueID }
        case .fan:
            viewIDs = WidgetViewList.fan.map { $0.uniqueID }
        case .climate, .switch:
            viewIDs = []
        }
    }
}

// MARK: - Private Methods

extension WidgetEditViewModelImpl {

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

    public func updateWidget() {
        guard let widgetIndex = dashboard.widgetConfigs.firstIndex(where: { $0.id == widgetData.config.id }) else {
            return
        }

        var dashboard = dashboard
        let widgetConfig = WidgetConfig(
            id: widgetData.config.id,
            entityID: widgetData.config.entityID,
            uiType: selectedViewID
        )

        dashboard.widgetConfigs[widgetIndex] = widgetConfig
        do {
            try dashboardService.update(
                dashboardName: dashboard.name,
                dashboard: dashboard
            )
            delegate?.didFinish()
        } catch {
            setError(message: Localizable.updateError.value)
        }
    }

    public func close() {
        delegate?.didClose()
    }
}
