//
//  DashboardCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import SwiftUI
import Dashboard

struct DashboardCoordinator<ViewModel: DashboardViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        DashboardView(viewModel: viewModel)
            .task { viewModel.delegate = self }
    }
}

extension DashboardCoordinator: DashboardExternalFlow {
    func didSelectAddWidget(_ dashboard: Domain.Dashboard) {
        coordinator.preset(sheet: .widgetEdit(dashboard: dashboard, mode: .creation))
    }

    func didSelectEditWidget(_ widgetData: WidgetData, _ dashboard: Dashboard) {
        coordinator.preset(sheet: .widgetEdit(dashboard: dashboard, mode: .edit(widgetData: widgetData)))
    }

    func didSelectConfig() -> Void {
        coordinator.preset(sheet: .config)
    }

    func didSelectAddDashboard() -> Void {
        coordinator.preset(sheet: .dashboardEdit(mode: .creation))
    }

    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void {
        coordinator.preset(sheet: .dashboardEdit(mode: .edit(dashboard)))
    }
}
