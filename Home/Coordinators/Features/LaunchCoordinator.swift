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
            .onAppear(perform: setupCallbacks)
    }

    private func setupCallbacks() {
        viewModel.launchFinished = { [self] in
            coordinator.root = .dashboard
        }
    }
}
