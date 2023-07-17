//
//  DashboardView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

public struct DashboardView: View {

    @ObservedObject private var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            Text("Dashboard")
            Button("Click Here!") {
                viewModel.buttonDidClick?()
            }
        }
    }
}
