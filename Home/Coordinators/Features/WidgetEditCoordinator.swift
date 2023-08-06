//
//  WidgetEditCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 06/08/23.
//

import Domain
import SwiftUI
import WidgetEdit

struct WidgetEditCoordinator<ViewModel: WidgetEditViewModel>: View {

    @EnvironmentObject private var coordinator: Coordinator
    @State private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            WidgetEditView(viewModel: viewModel)
        }
        .task { viewModel.delegate = self }
    }
}

extension WidgetEditCoordinator: WidgetEditExternalFlow {

    func didFinish(_ widget: WidgetConfig) {

    }

    func didClose() {
        coordinator.dismiss()
    }
}
