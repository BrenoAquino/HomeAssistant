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

            switch viewModel.state {
            case .loading:
                loadingState
            case .error:
                errorState
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColor.background)
        .toast(data: $viewModel.toastData)
        .task {
            await viewModel.configure()
        }
    }

    private var loadingState: some View {
        LoadingView()
            .tint(DSColor.label)
            .opacityTransition()
    }

    private var errorState: some View {
        Button(Localizable.tryAgain.value) {
            Task {
                await viewModel.configure()
            }
        }
        .foregroundColor(DSColor.link)
        .opacityTransition()
    }
}

#if DEBUG
struct LaunchView_Preview: PreviewProvider {

    static var previews: some View {

        LaunchView(viewModel: LaunchViewModelPreview(state: .loading))
    }
}
#endif
