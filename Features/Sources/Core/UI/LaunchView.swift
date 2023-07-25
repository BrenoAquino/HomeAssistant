//
//  LaunchView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import DesignSystem

public struct LaunchView<ViewModel: LaunchViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Spacer()

            Image(packageResource: .whiteLogo)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .foregroundColor(DSColor.label)

            Spacer()

            if viewModel.state == .loading {
                LoadingView()
                    .tint(DSColor.label)
                    .opacityTransition()
            } else {
                Button(Localizable.tryAgain.value) {
                    Task { await viewModel.startConfiguration() }
                }
                .foregroundColor(DSColor.link)
                .opacityTransition()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColor.background)
        .toast(data: $viewModel.toastData)
        .task {
            await viewModel.startConfiguration()
        }
    }
}

#if DEBUG
struct LaunchView_Preview: PreviewProvider {

    static var previews: some View {

        LaunchView(viewModel: LaunchViewModelPreview(state: .loading))
    }
}
#endif
