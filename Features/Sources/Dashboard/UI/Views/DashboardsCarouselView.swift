//
//  DashboardsCarouselView.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Common
import DesignSystem
import SwiftUI
import UniformTypeIdentifiers

private enum Constants {

    static let dashboardImageHeight: CGFloat = 80
    static let dashboardImageWidth: CGFloat = dashboardImageHeight
    static let dashboardStrokeWidth: CGFloat = 1
    static let shakeAnimationAngle: CGFloat = 5
    static let removeIconHeight: CGFloat = 25
    static let removeIconWidth: CGFloat = removeIconHeight
}

struct DashboardsCarouselView<Model: DashboardUI>: View {

    @Binding var editMode: Bool
    @Binding var dashboards: [Model]
    @Binding var selectedDashboard: String

    let dashboardDidEdit: (_ dashboard: Model) -> Void
    let dashboardDidRemove: (_ dashboard: Model) -> Void
    let addDidSelect: () -> Void

    // MARK: Private States

    @State private var draggedItem: Model?
    @State private var isDragging: Bool = false

    // MARK: View

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallL) {
                carousel
                add
            }
            .padding(.horizontal, space: .smallL)
            .padding(.vertical, space: .normal)
        }
    }

    private var add: some View {
        squareElement("", "plus.circle", false)
            .onTapGesture {
                if !editMode {
                    addDidSelect()
                }
            }
    }

    private var carousel: some View {
        ForEach(dashboards, id: \.name) { dashboard in
            let shakeAnimation = Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
            let isSelected = dashboard.name == selectedDashboard
            let squareElementView = squareElement(dashboard.name, dashboard.icon, isSelected)
            let isCurrentElementDragging = draggedItem?.name == dashboard.name
            let shouldHide = isDragging && isCurrentElementDragging

            squareElementView
                .overlay(removeIcon(dashboard))
                .rotationEffect(.degrees(editMode ? Constants.shakeAnimationAngle : .zero))
                .animation(editMode ? shakeAnimation : .default, value: editMode)
                .opacity(shouldHide ? .leastNonzeroMagnitude : 1)
                .onTapGesture {
                    if editMode {
                        dashboardDidEdit(dashboard)
                    } else {
                        selectedDashboard = dashboard.name
                    }
                }
                .onDrop(of: [.text], delegate: DashboardDropDelegate(
                    dashboard: dashboard,
                    dashboards: $dashboards,
                    draggedItem: $draggedItem,
                    isDragging: $isDragging
                ))
                .onDrag {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    editMode = true
                    draggedItem = dashboard
                    return NSItemProvider(item: nil, typeIdentifier: dashboard.name)
                } preview: { squareElementView }
        }
    }

    private func removeIcon(_ dashboard: Model) -> some View {
        GeometryReader { _ in
            SystemImages.remove
                .imageScale(.large)
                .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
                .offset(x: -Constants.removeIconWidth / 3, y: -Constants.removeIconHeight / 3)
                .opacity(editMode ? 1 : 0)
                .animation(.default, value: editMode)
                .onTapGesture {
                    dashboardDidRemove(dashboard)
                }
        }
    }

    func squareElement(
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

    private struct DashboardDropDelegate<Model: DashboardUI>: DropDelegate {

        let dashboard: Model
        @Binding var dashboards: [Model]
        @Binding var draggedItem: Model?
        @Binding var isDragging: Bool

        func performDrop(info: DropInfo) -> Bool {
            isDragging = false
            draggedItem = nil
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

    struct DashboardMock: DashboardUI {
        let name: String
        let icon: String
    }

    static var previews: some View {
        DashboardsCarouselView(
            editMode: .constant(true),
            dashboards: .constant([
                DashboardMock(name: "Bedroom", icon: "bed.double"),
                DashboardMock(name: "Living Room", icon: "sofa"),
                DashboardMock(name: "Kitchen", icon: "refrigerator"),
                DashboardMock(name: "Garden", icon: "tree"),
                DashboardMock(name: "Security", icon: "light.beacon.max"),
            ]),
            selectedDashboard: .constant("Bedroom"),
            dashboardDidEdit: { _ in print("dashboardDidEdit") },
            dashboardDidRemove: { _ in print("dashboardDidRemove") },
            addDidSelect: { print("addDidSelect") }
        )
    }
}
#endif
