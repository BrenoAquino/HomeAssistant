//
//  DashboardsCarouselView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Common
import DesignSystem
import SwiftUI
import UniformTypeIdentifiers

private enum Constants {

    static let animationDuration: TimeInterval = 0.15
    static let shadowOpacity: CGFloat = 0.2
    static let dashboardImageHeight: CGFloat = 80
    static let dashboardImageWidth: CGFloat = dashboardImageHeight
    static let dashboardStrokeWidth: CGFloat = 1
    static let shakeAnimationAngle: CGFloat = 5
    static let removeIconHeight: CGFloat = 25
    static let removeIconWidth: CGFloat = removeIconHeight
}

struct DashboardsCarouselView: View {
    let dashboards: [Dashboard]
    @Binding var selectedDashboardName: String?

    let didClickAdd: () -> Void

    // MARK: Private States

    @State private var draggedItem: Dashboard?
    @State private var isDragging: Bool = false

    // MARK: View

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallS) {
                carousel
                add
            }
            .padding(.vertical, space: .normal)
            .padding(.horizontal, space: .horizontal)
            .padding(.top, -Constants.removeIconHeight / 3)
            .padding(.leading, -Constants.removeIconWidth / 3)
        }
    }

    private var add: some View {
        element("", "plus.circle", false)
            .onTapGesture(perform: didClickAdd)
    }

    private var carousel: some View {
        ForEach(dashboards, id: \.name) { dashboard in
            let isSelected = dashboard.name == selectedDashboardName
            element(
                dashboard.name,
                dashboard.icon,
                isSelected
            )
            .onTapGesture {
                selectedDashboardName = dashboard.name
            }
        }
    }

    private func element(
        _ title: String,
        _ icon: String,
        _ isSelected: Bool
    ) -> some View {
        VStack(spacing: .smallM) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? DSColor.background : DSColor.label)
                .frame(width: Constants.dashboardImageWidth, height: Constants.dashboardImageHeight)
                .background(isSelected ? DSColor.selected : DSColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: .hard)
                        .stroke(DSColor.gray3, lineWidth: Constants.dashboardStrokeWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: .hard))

            Text(title)
                .lineLimit(1)
                .font(.subheadline)
        }
        .shadow(radius: .veryEasy, color: .black.opacity(Constants.shadowOpacity))
        .padding(.leading, Constants.removeIconWidth / 3)
        .padding(.top, Constants.removeIconHeight / 3)
    }
}

#if DEBUG
import Preview

struct DashboardsCarouselView_Preview: PreviewProvider {

    static var previews: some View {
        DashboardsCarouselView(
            dashboards: Dashboard.all,
            selectedDashboardName: .constant("Bedroom"),
            didClickAdd: { }
        )
    }
}
#endif
