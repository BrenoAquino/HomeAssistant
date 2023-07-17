//
//  LaunchCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Launch

struct LaunchCoordinator: View {

    // MARK: Coordinator
    @ObservedObject var viewModel: LaunchCoordinatorViewModel

    init(viewModel: LaunchCoordinatorViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Self View
    var body: some View {
        LaunchView(viewModel: viewModel.launchViewModel)
    }
}
