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
        coordinator.preset(sheet: .config(style: .default))
    }

    func didSelectAddDashboard() -> Void {
        coordinator.preset(sheet: .dashboardCreation(style: .default, mode: .creation))
    }

    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void {
        coordinator.preset(sheet: .dashboardCreation(style: .default, mode: .edit(dashboard)))
    }
}
