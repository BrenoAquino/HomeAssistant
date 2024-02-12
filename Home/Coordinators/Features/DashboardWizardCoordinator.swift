//
//  DashboardWizardCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import SwiftUI
import DashboardWizard

struct DashboardWizardCoordinator<ViewModel: DashboardWizardViewModel>: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        DashboardWizardView(viewModel: viewModel)
            .task {
                viewModel.externalFlows = self
            }
    }
}

extension DashboardWizardCoordinator: DashboardWizardExternalFlow {
    func didFinish() {
        coordinator.pop()
    }

    func didClose() {
        coordinator.pop()
    }
}
