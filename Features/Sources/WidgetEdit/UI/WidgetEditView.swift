//
//  WidgetEditView.swift
//
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import SwiftUI

public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: .zero) {
            steps
        }
        .navigationTitle(
            viewModel.mode == .creation ?
            Localizable.creationTitle.value :
            Localizable.editTitle.value
        )
        .toolbar {
            closeButton
        }
    }

    private var closeButton: some View {
        Button(action: viewModel.close) {
            SystemImages.close
                .imageScale(.large)
                .foregroundColor(DSColor.label)
        }
        .foregroundColor(DSColor.label)
    }

    private var steps: some View {
        TabView(selection: $viewModel.currentStep) {
//            WidgetEntitySelectionView()
//                .tag(0)
//                .disablePageSwipe()

            WidgetUISelectionView()
                .tag(1)
                .disablePageSwipe()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

private extension View {

    func disablePageSwipe() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(DragGesture())
    }
}

#if DEBUG
struct WidgetEditView_v2_Preview: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            WidgetEditView(viewModel: WidgetEditViewModelPreview())
        }
    }
}
#endif
