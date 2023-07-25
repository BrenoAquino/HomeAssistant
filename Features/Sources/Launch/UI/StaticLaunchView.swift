//
//  StaticLaunchView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

public struct StaticLaunchView: View {

    public init() {}

    public var body: some View {
        Image(packageResource: .whiteLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
