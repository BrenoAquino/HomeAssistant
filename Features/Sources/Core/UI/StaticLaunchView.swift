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
        Image(packageResource: .whiteLogo)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(DSColor.label)
            .background(Color.black)
    }
}

#if DEBUG
struct StaticLaunchView_Preview: PreviewProvider {

    static var previews: some View {

        StaticLaunchView()
    }
}
#endif
