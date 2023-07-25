//
//  ErrorLaunchView.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import DesignSystem
import SwiftUI

public struct ErrorLaunchView<ViewModel: LaunchViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        StaticLaunchView()
            .overlay(
                GeometryReader { proxy in
                    Button("Try to connect again") {
                        Task { await viewModel.startConfiguration() } 
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: proxy.size.height * 3 / 4)
                }
            )
    }
}

#if DEBUG
struct ErrorLaunchView_Preview: PreviewProvider {

    static var previews: some View {

        ErrorLaunchView(viewModel: LaunchViewModelPreview())
    }
}
#endif
