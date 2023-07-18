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
    var selectedRoom: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallL) {
                ForEach(Array(dashboards.enumerated()), id: \.element.id) { (offset, dashboardUI) in
                    squareElement(dashboardUI.name, dashboardUI.icon, offset)
                }
                squareElement("", "plus.circle", dashboards.count + 1)
            }
            .padding(.horizontal, space: .smallL)
        }
    }

    @ViewBuilder func squareElement(
        _ title: String,
        _ icon: String,
        _ offset: Int
    ) -> some View {
        let isSelected = offset == selectedRoom

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

        DashboardsCarouselView(
            dashboards: DashboardServiceMock().dashboards,
            selectedRoom: 4
        )
    }
}
#endif
