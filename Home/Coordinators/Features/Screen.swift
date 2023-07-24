//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import DashboardCreation

enum Screen: Identifiable, Hashable {
    case launch
    case dashboard
    case dashboardCreation(mode: DashboardCreationMode)
    case config

    var id: String { String(describing: self) }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Screen {

    @ViewBuilder func viewCoordinator(_ factory: Factory) -> some View {
        switch self {
        case .launch:
            factory.getLaunchCoordinator()
        case .dashboard:
            factory.getDashboardCoordinator()
        case .dashboardCreation(let mode):
            factory.getDashboardCreationCoordinator(mode: mode)
        case .config:
            factory.getConfigCoordinator()
        }
    }
}
