//
//  DashboardCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Dashboard

struct DashboardCoordinator: View {

    @EnvironmentObject private var coordinator: Coordinator
    private let viewModel: DashboardViewModel

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        DashboardView(viewModel: viewModel)
    }
}
