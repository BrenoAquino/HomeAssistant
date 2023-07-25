//
//  ErrorLaunchCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI
import Core

struct ErrorLaunchCoordinator<ViewModel: LaunchViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        LaunchView(viewModel: viewModel)
            .task { viewModel.delegate = self }
    }
}

extension ErrorLaunchCoordinator: LaunchExternalFlow {

    func launchFinished() {
        if coordinator.block == nil {
            coordinator.root = .dashboard(style: .default)
        } else {
            coordinator.block = nil
        }
    }
}
