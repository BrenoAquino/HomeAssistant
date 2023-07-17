//
//  CoordinatorFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

class CoordinatorFactory {

    private let viewModelFactory: ViewModelFactory

    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    func launch() -> LaunchCoordinator {
        LaunchCoordinator(viewModel: viewModelFactory.launchCoordinator())
    }
}
