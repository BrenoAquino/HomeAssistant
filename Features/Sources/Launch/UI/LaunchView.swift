//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

public struct LaunchView: View {

    @ObservedObject private var viewModel: LaunchViewModel

    public init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Image(packageResource: .whiteLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .task {
                await viewModel.startConfiguration()
            }
    }
}

#if DEBUG
import Preview

struct LaunchView_Preview: PreviewProvider {

    static var previews: some View {
        LaunchView(viewModel: .init(entityService: EntityServiceMock()))
    }
}
#endif
