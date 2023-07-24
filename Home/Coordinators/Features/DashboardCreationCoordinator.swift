//
//  DashboardCreationCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import SwiftUI
import DashboardCreation

struct DashboardCreationCoordinator<ViewModel: DashboardCreationViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        DashboardCreationView(viewModel: viewModel)
            .task { viewModel.delegate = self }
    }
}

extension DashboardCreationCoordinator: DashboardCreationExternalFlow {

    func didFinish() {
        coordinator.dismiss()
    }

    func didClose() {
        coordinator.dismiss()
    }
}
