//
//  ScreenDestination.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import DashboardEdit
import Foundation

enum ScreenDestination {

    case launch
    case staticLaunch
    case dashboard
    case dashboardEdit(mode: DashboardEditMode)
    case config
}

extension ScreenDestination {

    func screen(factory: ScreenFactory) -> Screen {

        switch self {
        case .launch:
            return factory.launchScreen()
        case .staticLaunch:
            return factory.staticLaunchScreen()
        case .dashboard:
            return factory.dashboardScreen()
        case .dashboardEdit(let mode):
            return factory.dashboardEditScreen(mode: mode)
        case .config:
            return factory.configScreen()
        }
    }
}
