//
//  DashboardView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Common
import DesignSystem
import SwiftUI

public struct DashboardView: View {

    @ObservedObject private var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView(.vertical) {
            Localizable.welcome.text
                .foregroundColor(SystemColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.leading, space: .smallL)
                .padding(.top, space: .smallS)

            DashboardsCarouselView(
                dashboards: viewModel.dashboards,
                selectedIndex: viewModel.selectedIndex,
                dashboardDidSelect: viewModel.selectDashboard,
                dashboardDidRemove: viewModel.removeDashboard,
                addDidSelect: viewModel.didSelectAdd
            )
            .padding(.top, space: .smallS)
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
