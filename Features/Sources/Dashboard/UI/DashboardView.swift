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
                .foregroundColor(SystemColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.leading, space: .smallL)
                .padding(.top, space: .smallS)

            DashboardsCarouselView(dashboards: viewModel.dashboards, selectedRoom: 0)
                .padding(.top, space: .smallM)
        }
        .navigationTitle(Localizable.hiThere.value)
    }
}

#if DEBUG
import Preview

struct DashboardView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init(dashboardService: DashboardServiceMock()))
        }
    }
}
#endif
