//
//  ConfigCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 24/07/23.
//

import Domain
import SwiftUI
import Config

struct ConfigCoordinator<ViewModel: ConfigViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ConfigView(viewModel: viewModel)
        }
        .task { viewModel.delegate = self }
    }
}

extension ConfigCoordinator: ConfigExternalFlow {

    func didClose() {
        coordinator.dismiss()
    }
}
