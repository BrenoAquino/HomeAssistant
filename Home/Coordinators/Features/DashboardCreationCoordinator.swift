////
////  DashboardCreationCoordinator.swift
////  Home
////
////  Created by Breno Aquino on 18/07/23.
////
//
//import SwiftUI
//import DashboardCreation
//
//struct DashboardCreationCoordinator: View {
//
//    @EnvironmentObject private var coordinator: Coordinator
//    @State private var viewModel: DashboardCreationViewModel
//
//    init(viewModel: DashboardCreationViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body: some View {
//        DashboardCreationView(viewModel: viewModel)
//            .task { setupCallbacks() }
//    }
//
//    private func setupCallbacks() {
//        viewModel.didClose = { [self] in
//            coordinator.dismiss()
//        }
//
//        viewModel.didFinish = { [self] in
//            coordinator.dismiss()
//        }
//    }
//}
