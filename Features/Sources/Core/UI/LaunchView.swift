//
//  LaunchView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

public struct LaunchView<ViewModel: LaunchViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        StaticLaunchView()
            .overlay(
                GeometryReader { proxy in
                    Button("Try to connect again") {

                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: proxy.size.height * 3 / 4)
                }
            )
            .task {
                await viewModel.startConfiguration()
            }
    }
}

#if DEBUG
struct LaunchView_Preview: PreviewProvider {

    static var previews: some View {

        LaunchView(viewModel: LaunchViewModelPreview())
    }
}
#endif
