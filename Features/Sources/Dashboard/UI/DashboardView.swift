//
//  DashboardView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

public struct DashboardView: View {

    @ObservedObject private var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView(.vertical) {
            Text(localizable: .welcome)
//                .foregroundColor(.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.leading, space: .smallL)
                .padding(.top, space: .smallS)
        }
        .navigationTitle(Localizable.hiThere.value)
    }

    // MARK: Components

    
}

#if DEBUG
struct DashboardView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init())
        }
    }
}
#endif
