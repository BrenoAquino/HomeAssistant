//
//  DashboardEditCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import SwiftUI
import DashboardEdit

struct DashboardEditCoordinator<ViewModel: DashboardEditViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            DashboardEditView(viewModel: viewModel)
        }
        .task { viewModel.delegate = self }
    }
}

extension DashboardEditCoordinator: DashboardEditExternalFlow {

    func didFinish() {
        coordinator.dismiss()
    }

    func didClose() {
        coordinator.dismiss()
    }
}
