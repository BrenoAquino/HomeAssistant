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

    @Binding var editMode: Bool
    @Binding var dashboards: [Dashboard]
    @Binding var selectedDashboardName: String?

    let didUpdateOrder: (_ dashboards: [Dashboard]) -> Void
    let didClickRemoveDashboard: (_ dashboard: Dashboard) -> Void
    let didClickEditDashboard: (_ dashboard: Dashboard) -> Void
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
        squareContent("", "plus.circle", false)
            .onTapGesture {
                if !editMode {
                    didClickAdd()
                }
            }
    }

    private var carousel: some View {
        ForEach(dashboards, id: \.name) { dashboard in
            let shakeAnimation = Animation.easeInOut(duration: Constants.animationDuration).repeatForever(autoreverses: true)
            let isSelected = dashboard.name == selectedDashboardName

            element(dashboard, isSelected)
                .rotationEffect(.degrees(editMode ? Constants.shakeAnimationAngle : .zero))
                .animation(editMode ? shakeAnimation : .default, value: editMode)
                .onTapGesture {
                    if editMode {
                        didClickEditDashboard(dashboard)
                    } else if !isSelected {
                        selectedDashboardName = dashboard.name
                    }
                }
                .onDrop(of: [.text], delegate: DashboardDropDelegate(
                    dashboard: dashboard,
                    dashboards: $dashboards,
                    draggedItem: $draggedItem,
                    isDragging: $isDragging,
                    didUpdateOrder: didUpdateOrder
                ))
                .onDrag {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    editMode = true
                    draggedItem = dashboard
                    return NSItemProvider(item: nil, typeIdentifier: dashboard.name)
                } preview: { EmptyView() }
        }
    }

    private func element(
        _ dashboard: Dashboard,
        _ isSelected: Bool
    ) -> some View {
        ZStack(alignment: .topLeading) {
            squareContent(
                dashboard.name,
                dashboard.icon,
                isSelected
            )

            SystemImages.remove
                .imageScale(.large)
                .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
                .opacity(editMode ? 1 : 0)
                .animation(.default, value: editMode)
                .onTapGesture {
                    didClickRemoveDashboard(dashboard)
                }
        }
    }

    private func squareContent(
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

    private struct DashboardDropDelegate: DropDelegate {

        let dashboard: Dashboard
        @Binding var dashboards: [Dashboard]
        @Binding var draggedItem: Dashboard?
        @Binding var isDragging: Bool
        let didUpdateOrder: (_ entities: [Dashboard]) -> Void

        func performDrop(info: DropInfo) -> Bool {
            isDragging = false
            draggedItem = nil
            didUpdateOrder(dashboards)
            return true
        }

        func dropEntered(info: DropInfo) {
            isDragging = true
            guard
                let draggedItem,
                draggedItem.name != dashboard.name,
                let from = dashboards.firstIndex(where: { $0.name == draggedItem.name }),
                let to = dashboards.firstIndex(where: { $0.name == dashboard.name })
            else { return }

            withAnimation {
                dashboards.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}

#if DEBUG
import Preview

struct DashboardsCarouselView_Preview: PreviewProvider {

    static var previews: some View {
        DashboardsCarouselView(
            editMode: .constant(false),
            dashboards: .constant(DashboardMock.all),
            selectedDashboardName: .constant("Bedroom"),
            didUpdateOrder: { _ in print ("didUpdateOrder") },
            didClickRemoveDashboard: { _ in print("dashboardDidRemove") },
            didClickEditDashboard: { _ in print("dashboardDidEdit") },
            didClickAdd: { print("addDidSelect") }
        )
    }
}
#endif
