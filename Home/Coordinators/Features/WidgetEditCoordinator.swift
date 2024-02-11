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
        WidgetEditView(viewModel: viewModel)
            .task { viewModel.delegate = self }
    }
}

extension WidgetEditCoordinator: WidgetEditExternalFlow {
    func didClose() {
        coordinator.dismiss()
    }
}
