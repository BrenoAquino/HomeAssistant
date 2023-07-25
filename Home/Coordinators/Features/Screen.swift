//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import DashboardCreation

struct PresentationStyle {}

enum Screen: Identifiable, Hashable {

    case launch(style: PresentationStyle)
    case staticLaunch(style: PresentationStyle)
    case dashboard(style: PresentationStyle)
    case dashboardCreation(style: PresentationStyle, mode: DashboardCreationMode)
    case config(style: PresentationStyle)
}

extension Screen {

    @ViewBuilder func viewCoordinator(_ factory: Factory) -> some View {
        switch self {
        case .launch:
            factory.getLaunchCoordinator().transition(.opacity)
        case .staticLaunch:
            factory.getStaticLaunchCoordinator().transition(.opacity)
        case .dashboard:
            factory.getDashboardCoordinator()
        case .dashboardCreation(_, let mode):
            factory.getDashboardCreationCoordinator(mode: mode)
        case .config:
            factory.getConfigCoordinator()
        }
    }
}
