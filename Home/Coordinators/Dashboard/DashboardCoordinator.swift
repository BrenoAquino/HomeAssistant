//
//  DashboardCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Dashboard

struct DashboardCoordinator: View {

    // MARK: Coordinator
    @ObservedObject var viewModel: DashboardCoordinatorViewModel

    init(viewModel: DashboardCoordinatorViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Self View
    var body: some View {
        DashboardView()
    }
}
