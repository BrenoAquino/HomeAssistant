//
//  LaunchCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Launch

struct LaunchCoordinator: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: LaunchViewModel

    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        LaunchView(viewModel: viewModel)
            .onAppear(perform: setupCallbacks)
    }

    private func setupCallbacks() {
        viewModel.launchFinished = { [self] in
            coordinator.root = .dashboard
        }
    }
}
