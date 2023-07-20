//
//  DashboardCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Dashboard

struct DashboardCoordinator: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        DashboardView(viewModel: viewModel)
            .task { setupCallbacks() }
    }

    private func setupCallbacks() {
        viewModel.didSelectAddDashboard = { [self] in
            self.coordinator.preset(sheet: .dashboardCreation(mode: .creation))
        }

        viewModel.didSelectEditDashboard = { [self] dashboard in
            self.coordinator.preset(sheet: .dashboardCreation(mode: .edit(dashboard)))
        }
    }
}
