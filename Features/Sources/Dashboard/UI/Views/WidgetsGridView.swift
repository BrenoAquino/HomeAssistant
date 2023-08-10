//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import DesignSystem
import Domain
import SwiftUI

private enum Constants {

    static let animationDuration: TimeInterval = 0.15
    static let shakeAnimationAngle: CGFloat = 5
    static let removeIconHeight: CGFloat = 25
    static let removeIconWidth: CGFloat = removeIconHeight
    static let minWidgetSize: CGFloat = 100
}

struct WidgetsGridView: View {

    private typealias WidgetViewData = (widget: WidgetData?, columns: Int, rows: Int)

    @Binding var editMode: Bool
    @Binding var widgets: [WidgetData]

    let didUpdateWidgetsOrder: (_ widgets: [WidgetData]) -> Void
    let didClickRemoveWidget: (_ widget: WidgetData) -> Void
    let didClickEditWidget: (_ widget: WidgetData) -> Void

    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void
    let didClickUpdateFanState: (_ fanEntity: FanEntity, _ newState: FanEntity.State) -> Void

    @State private var draggedItem: WidgetData?
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let space: DSSpace = .horizontal
            let columnsLimit = Int((proxy.size.width - space.rawValue) / (Constants.minWidgetSize + space.rawValue))
            let columnsWidth = (proxy.size.width - CGFloat(columnsLimit + 1) * space.rawValue) / CGFloat(columnsLimit)
            let matrix = calculateRows(widgets, columnsLimit)

            Grid(
                horizontalSpacing: space.rawValue,
                verticalSpacing: space.rawValue
            ) {
                ForEach(Array(matrix.enumerated()), id: \.offset) { _, row in
                    GridRow {
                        ForEach(Array(row.enumerated()), id: \.offset) { _, widgetViewData in
                            if let widget = widgetViewData.widget {
                                gridCell(widget, widgetViewData.columns, widgetViewData.rows)
                            } else {
                                Color.clear.gridCellColumns(widgetViewData.columns)
                            }
                        }
                    }
                    .frame(height: columnsWidth)
                }
            }
            .padding(.horizontal, space: space)
        }
    }

    private func calculateRows(
        _ widgets: [WidgetData],
        _ columnsNumber: Int
    ) -> [[WidgetViewData]] {

        var columnsCount: Int = .zero
        var currentRow: Int = .zero
        var matrix: [[WidgetViewData]] = [[]]

        for widget in widgets {
            let (columns, rows) = WidgetSize.units(for: widget.config.uiType, entity: widget.entity)

            if columnsCount + columns > columnsNumber {
                let remainingColumns = columnsNumber - columnsCount
                if remainingColumns > 0 {
                    matrix[currentRow].append((nil, remainingColumns, 1))
                }
                columnsCount = 0
                currentRow += 1
                matrix.append([])
            }

            columnsCount += columns
            matrix[currentRow].append((widget, columns, rows))
        }

        if columnsCount < columnsNumber {
            matrix[currentRow].append((nil, columnsNumber - columnsCount, 1))
        }

        return matrix
    }

    @ViewBuilder
    private func gridCell(
        _ widget: WidgetData,
        _ columns: Int,
        _ rows: Int
    ) -> some View {
        let shakeAnimation = Animation.easeInOut(duration: Constants.animationDuration).repeatForever(autoreverses: true)
        widgetElement(widget)
            .gridCellColumns(columns)
            .rotationEffect(editMode ? .degrees(Constants.shakeAnimationAngle) : .zero)
            .animation(editMode ? shakeAnimation : .default, value: editMode)
            .padding(.leading, -Constants.removeIconWidth / 3)
            .padding(.top, -Constants.removeIconHeight / 3)
            .onDrop(of: [.text], delegate: WidgetDropDelegate(
                widget: widget,
                widgets: $widgets,
                draggedItem: $draggedItem,
                isDragging: $isDragging,
                didUpdateOrder: didUpdateWidgetsOrder
            ))
            .onDrag {
                draggedItem = widget
                editMode = true
                return NSItemProvider(object: widget.config.id as NSString)
            } preview: { EmptyView() }
    }

    @ViewBuilder
    private func widgetElement(
        _ widget: WidgetData
    ) -> some View {
        ZStack(alignment: .topLeading) {
            widgetView(widget)
                .padding(.leading, Constants.removeIconWidth / 3)
                .padding(.top, Constants.removeIconHeight / 3)

            SystemImages.remove
                .imageScale(.large)
                .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
                .opacity(editMode ? 1 : 0)
                .animation(.default, value: editMode)
                .onTapGesture {
                    didClickRemoveWidget(widget)
                }
        }
    }

    @ViewBuilder
    private func widgetView(
        _ widget: WidgetData
    ) -> some View {
        switch widget.entity {
        case let light as LightEntity:
            lightWidgetView(widget, light)
        case let fan as FanEntity:
            fanWidgetView(widget, fan)
        default:
            UnsupportedWidgetView(title: widget.entity.name)
        }
    }

    @ViewBuilder
    private func lightWidgetView(
        _ widgetData: WidgetData,
        _ lightEntity: LightEntity
    ) -> some View {
        switch widgetData.config.uiType {
        default:
            LightWidgetView(
                lightEntity: lightEntity,
                title: widgetData.config.title
            ) {
                if editMode {
                    didClickEditWidget(widgetData)
                } else {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    didClickUpdateLightState($0, $1)
                }
            }
        }
    }

    @ViewBuilder
    private func fanWidgetView(
        _ widgetData: WidgetData,
        _ fanEntity: FanEntity
    ) -> some View {
        switch widgetData.config.uiType {
        case FanSliderWidgetView.uniqueID:
            FanSliderWidgetView(
                fanEntity: fanEntity,
                title: widgetData.config.title
            ) {
                if editMode {
                    didClickEditWidget(widgetData)
                } else {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    didClickUpdateFanState($0, $1)
                }
            }
        default:
            FanWidgetView(
                fanEntity: fanEntity,
                title: widgetData.config.title
            ) {
                if editMode {
                    didClickEditWidget(widgetData)
                } else {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    didClickUpdateFanState($0, $1)
                }
            }
        }
    }
}

// MARK: - DropDelegate

private struct WidgetDropDelegate: DropDelegate {

    let widget: WidgetData
    @Binding var widgets: [WidgetData]
    @Binding var draggedItem: WidgetData?
    @Binding var isDragging: Bool
    let didUpdateOrder: (_ widgets: [WidgetData]) -> Void

    func performDrop(info: DropInfo) -> Bool {
        isDragging = false
        draggedItem = nil
        didUpdateOrder(widgets)
        return true
    }

    func dropEntered(info: DropInfo) {
        isDragging = true
        guard
            let draggedItem,
            let fromIndex = widgets.firstIndex(where: { $0.config.id == draggedItem.config.id }),
            let toIndex = widgets.firstIndex(where: { $0.config.id == widget.config.id })
        else { return }

        withAnimation {
            widgets.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
            )
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

// MARK: - Preview

#if DEBUG
import Preview

struct WidgetsGridView_Preview: PreviewProvider {

    private static let widgets: [WidgetData] = [
        WidgetsMock.createFanWidget(uiType: "default", name: "Fan 1", state: .on),
        WidgetsMock.createLightWidget(uiType: "default", name: "Light 2", state: .on),
        WidgetsMock.createLightWidget(uiType: "default", name: "Light 3", state: .on),
        WidgetsMock.createLightWidget(uiType: "default", name: "Light 4", state: .on),
        WidgetsMock.createFanWidget(uiType: "default", name: "Fan 5", state: .on),
        WidgetsMock.createLightWidget(uiType: "default", name: "Light 6", state: .on),
    ]

    static var previews: some View {

        WidgetsGridView(
            editMode: .constant(false),
            widgets: .constant(widgets),
            didUpdateWidgetsOrder: { _ in },
            didClickRemoveWidget: { _ in },
            didClickEditWidget: { _ in },
            didClickUpdateLightState: { _, _ in },
            didClickUpdateFanState: { _, _ in }
        )
    }
}
#endif
