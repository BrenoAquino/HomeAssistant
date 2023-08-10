//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Foundation
import Domain
import SwiftUI

public class WidgetEditViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: WidgetEditViewModel {

    public var delegate: WidgetEditExternalFlow?
    public let mode: WidgetEditMode
    public let dashboard: Dashboard

    private let entityService: EntityS
    private let dashboardService: DashboardS

    public init(
        dashboardService: DashboardS,
        entityService: EntityS,
        mode: WidgetEditMode,
        dashboard: Dashboard
    ) {
        self.dashboardService = dashboardService
        self.entityService = entityService
        self.mode = mode
        self.dashboard = dashboard
    }

    public func entitySelection() -> AnyView {
        let viewModel = EntitySelectionViewModelImpl(entityService: entityService)
        viewModel.delegate = self
        return AnyView(WidgetEntitySelectionView(viewModel: viewModel))
    }

    public func uiSelection(_ entity: any Entity) -> AnyView {
        let viewModel = WidgetUISelectionViewModelImpl(
            dashboardService: dashboardService,
            dashboard: dashboard,
            entity: entity
        )
        viewModel.delegate = self
        return AnyView(WidgetUISelectionView(viewModel: viewModel))
    }

    public func uiSelection(_ widgetData: WidgetData) -> AnyView {
        let viewModel = WidgetUISelectionViewModelImpl(
            dashboardService: dashboardService,
            dashboard: dashboard,
            widgetData: widgetData
        )
        viewModel.delegate = self
        return AnyView(WidgetUISelectionView(viewModel: viewModel))
    }
}

extension WidgetEditViewModelImpl: EntitySelectionExternalFlow, WidgetUISelectionExternalFlow {

    func didClose() {
        delegate?.didClose()
    }
}
