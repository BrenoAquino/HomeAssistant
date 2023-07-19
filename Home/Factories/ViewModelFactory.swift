//
//  ViewModelFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation
import Launch
import Dashboard
import DashboardCreation

class ViewModelFactory {

    let servicesFactory: ServicesFactory

    init(servicesFactory: ServicesFactory) {
        self.servicesFactory = servicesFactory
    }
    
    func launch() -> LaunchViewModel {
        LaunchViewModel(entityService: servicesFactory.entity())
    }

    func dashboard() -> DashboardViewModel {
        DashboardViewModel(dashboardService: servicesFactory.dashboard())
    }

    func dashboardCreation() -> DashboardCreationViewModel {
        DashboardCreationViewModel(dashboardService: servicesFactory.dashboard())
    }
}
