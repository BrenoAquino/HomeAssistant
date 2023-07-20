//
//  CoordinatorFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import DashboardCreation
import Foundation

class CoordinatorFactory {

    private let viewModelFactory: ViewModelFactory

    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func launch() -> LaunchCoordinator {
        LaunchCoordinator(viewModel: viewModelFactory.launch())
    }

    func dashboard() -> DashboardCoordinator {
        DashboardCoordinator(viewModel: viewModelFactory.dashboard())
    }

    func dashboardCreation(mode: DashboardCreationMode) -> DashboardCreationCoordinator {
        DashboardCreationCoordinator(viewModel: viewModelFactory.dashboardCreation(mode: mode))
    }
}
