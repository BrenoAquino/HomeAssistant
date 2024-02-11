//
//  ScreenDestination.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Domain
import DashboardEdit
import WidgetEdit
import Foundation

enum ScreenDestination {
    case launch
    case staticLaunch
    case dashboard
    case dashboardEdit(mode: DashboardEditMode)
    case widgetEdit(dashboard: Dashboard, mode: WidgetEditMode)
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
        case .widgetEdit(let dashboard, let mode):
            return factory.widgetEdit(dashboard: dashboard, mode: mode)
        case .config:
            return factory.configScreen()
        }
    }
}
