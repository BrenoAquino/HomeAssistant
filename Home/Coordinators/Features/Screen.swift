//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

enum Screen: String, Identifiable {
    case launch
    case dashboard
    case dashboardCreation

    var id: String { rawValue }
}

extension Screen {

    @ViewBuilder func viewCoordinator(_ factory: Factory) -> some View {
        switch self {
        case .launch:
            factory.getLaunchCoordinator()
        case .dashboard:
            factory.getDashboardCoordinator()
        case .dashboardCreation:
            factory.getDashboardCreationCoordinator()
        }
    }
}
