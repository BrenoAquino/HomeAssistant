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
        VStack(spacing: .bigL) {
            Image(packageResource: .whiteLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
                .frame(maxWidth: .infinity)

            Button("Try to connect again") {
                Task { await viewModel.startConfiguration() }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#if DEBUG
struct ErrorLaunchView_Preview: PreviewProvider {

    static var previews: some View {

        ErrorLaunchView(viewModel: LaunchViewModelPreview())
    }
}
#endif
