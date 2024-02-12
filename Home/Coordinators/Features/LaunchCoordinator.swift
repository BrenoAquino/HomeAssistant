//
//  LaunchCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Launch

struct LaunchCoordinator<ViewModel: LaunchViewModel>: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        LaunchView(viewModel: viewModel)
            .task {
                viewModel.externalFlows = self
            }
    }
}

extension LaunchCoordinator: LaunchExternalFlow {
    func launchFinished() {
        if coordinator.block != nil {
            coordinator.dismissBlock()
        } else {
//            coordinator.setRoot(.dashboard)
        }
    }
}
