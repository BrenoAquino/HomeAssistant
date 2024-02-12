//
//  ScreenDestination.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Domain
//import DashboardEdit
//import WidgetEdit
import Foundation

enum ScreenDestination {
    case launch
    case staticLaunch
    case dashboard
    case config
//    case dashboardEdit(mode: DashboardEditMode)
//    case widgetEdit(dashboard: Dashboard, mode: WidgetEditMode)
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
        case .config:
            return factory.configScreen()
//        case .dashboardEdit(let mode):
//            return factory.dashboardEditScreen(mode: mode)
//        case .widgetEdit(let dashboard, let mode):
//            return factory.widgetEdit(dashboard: dashboard, mode: mode)
        }
    }
}
