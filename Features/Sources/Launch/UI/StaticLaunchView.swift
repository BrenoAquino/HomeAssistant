//
//  StaticLaunchView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

public struct StaticLaunchView: View {

    public init() {}

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
            LoadingView().opacity(0)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColor.background)
    }
}

#if DEBUG
struct StaticLaunchView_Preview: PreviewProvider {
    static var previews: some View {
        StaticLaunchView()
    }
}
#endif
