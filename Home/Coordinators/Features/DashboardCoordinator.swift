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
    
    func didSelectConfig() -> Void {
        let screen = Factory.shared.configScreen()
        coordinator.preset(sheet: screen)
    }

    func didSelectAddDashboard() -> Void {
        let screen = Factory.shared.dashboardCreationScreen(mode: .creation)
        coordinator.preset(sheet: screen)
    }

    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void {
        let screen = Factory.shared.dashboardCreationScreen(mode: .edit(dashboard))
        coordinator.preset(sheet: screen)
    }
}
