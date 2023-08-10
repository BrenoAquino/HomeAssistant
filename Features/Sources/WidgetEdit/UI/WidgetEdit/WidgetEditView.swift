//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import SwiftUI

public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            root
        }
    }

    @ViewBuilder public var root: some View {
        switch viewModel.mode {
        case .creation:
            AnyView(viewModel.entitySelection())
                .navigationDestination(for: AnyEntity.self) { elem in
                    viewModel.uiSelection(elem.entity)
                }

        case .edit(let widgetData):
            viewModel.uiSelection(widgetData)
        }
    }
}
