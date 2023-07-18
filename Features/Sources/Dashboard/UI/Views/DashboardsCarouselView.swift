//
//  DashboardsCarouselView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

struct DashboardsCarouselView: View {

    var dashboards: [any DashboardUI]
    var selectedIndex: Int
    var dashboardDidSelect: (_ dashboard: any DashboardUI, _ index: Int) -> Void
    var addDidSelect: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallL) {
                ForEach(Array(dashboards.enumerated()), id: \.element.id) { (offset, dashboardUI) in
                    squareElement(dashboardUI.name, dashboardUI.icon, offset)
                        .onTapGesture { dashboardDidSelect(dashboardUI, offset) }
                }
                squareElement("", "plus.circle", dashboards.count + 1)
                    .onTapGesture(perform: addDidSelect)
            }
            .padding(.horizontal, space: .smallL)
        }
    }

    @ViewBuilder func squareElement(
        _ title: String,
        _ icon: String,
        _ offset: Int
    ) -> some View {
        let isSelected = offset == selectedIndex

        VStack(spacing: .smallM) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? SystemColor.background : SystemColor.label)
                .frame(width: 80, height: 80)
                .background(isSelected ? SystemColor.label : SystemColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: .hard)
                        .stroke(
                            isSelected ? SystemColor.background : SystemColor.gray3,
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: .hard))

            Text(title)
                .font(.subheadline)
        }
    }
}

#if DEBUG
import Preview

struct DashboardsCarouselView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init(dashboardService: DashboardServiceMock()))
        }
    }
}
#endif
