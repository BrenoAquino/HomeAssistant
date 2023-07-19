//
//  DashboardsCarouselView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Common
import DesignSystem
import SwiftUI

private enum Constants {

    static let dashboardImageHeight: CGFloat = 80
    static let dashboardImageWidth: CGFloat = dashboardImageHeight
    static let dashboardStrokeWidth: CGFloat = 1
    static let shakeAnimationAngle: CGFloat = 5
    static let removeIconHeight: CGFloat = 25
    static let removeIconWidth: CGFloat = removeIconHeight
}

struct DashboardsCarouselView: View {

    let dashboards: [any DashboardUI]
    let selectedIndex: Int
    let dashboardDidSelect: (_ dashboard: any DashboardUI, _ index: Int) -> Void
    let dashboardDidRemove: (_ dashboard: any DashboardUI, _ index: Int) -> Void
    let addDidSelect: () -> Void

    @State private var editMode: Bool = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallL) {
                ForEach(Array(dashboards.enumerated()), id: \.element.name) { offset, dashboard in
                    let shakeAnimation = Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
                    let isSelected = offset == selectedIndex

                    squareElement(dashboard.name, dashboard.icon, isSelected)
                        .overlay(
                            GeometryReader { _ in
                                SystemImages.remove
                                    .imageScale(.large)
                                    .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
                                    .offset(x: -Constants.removeIconWidth / 3, y: -Constants.removeIconHeight / 3)
                                    .opacity(editMode ? 1 : 0)
                                    .animation(.default, value: editMode)
                                    .onTapGesture {
                                        dashboardDidRemove(dashboard, offset)
                                    }
                            }
                        )
                        .rotationEffect(.degrees(editMode ? Constants.shakeAnimationAngle : .zero))
                        .animation(editMode ? shakeAnimation : .default, value: editMode)
                        .onTapGesture { dashboardDidSelect(dashboard, offset) }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            editMode = !editMode
                        }
                }
                squareElement("", "plus.circle", false)
                    .onTapGesture(perform: addDidSelect)
            }
            .padding(.horizontal, space: .smallL)
            .padding(.vertical, space: .normal)
        }
    }

    @ViewBuilder func squareElement(
        _ title: String,
        _ icon: String,
        _ isSelected: Bool
    ) -> some View {
        VStack(spacing: .smallM) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? SystemColor.background : SystemColor.label)
                .frame(width: Constants.dashboardImageWidth, height: Constants.dashboardImageHeight)
                .background(isSelected ? SystemColor.label : SystemColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: .hard)
                        .stroke(
                            isSelected ? SystemColor.background : SystemColor.gray3,
                            lineWidth: Constants.dashboardStrokeWidth
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: .hard))

            Text(title)
                .lineLimit(1)
                .font(.subheadline)
        }
    }
}

#if DEBUG
import Preview

struct DashboardsCarouselView_Preview: PreviewProvider {

    struct DashboardMock: DashboardUI {
        let name: String
        let icon: String
    }

    static var previews: some View {
        DashboardsCarouselView(
            dashboards: [
                DashboardMock(name: "Bedroom", icon: "bed.double"),
                DashboardMock(name: "Living Room", icon: "sofa"),
                DashboardMock(name: "Kitchen", icon: "refrigerator"),
                DashboardMock(name: "Garden", icon: "tree"),
                DashboardMock(name: "Security", icon: "light.beacon.max"),
            ],
            selectedIndex: 0,
            dashboardDidSelect: { _, _ in print("dashboardDidSelect") },
            dashboardDidRemove: { _, _ in print("dashboardDidRemove") },
            addDidSelect: { print("addDidSelect") }
        )
    }
}
#endif
