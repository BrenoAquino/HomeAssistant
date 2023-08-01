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
}

struct WidgetsGridView: View {

    private typealias WidgetViewData = (widget: WidgetData, columns: Int, rows: Int)
    private typealias RowData = (id: UUID, data: [WidgetViewData])

    @Binding var editMode: Bool
    @Binding var widgets: [WidgetData]

    let didUpdateWidgetsOrder: (_ widgets: [WidgetData]) -> Void
    let didClickRemoveWidget: (_ widget: WidgetData) -> Void

    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void
    let didClickUpdateFanState: (_ fanEntity: FanEntity, _ newState: FanEntity.State) -> Void

    @State private var draggedItem: WidgetData?
    @State private var isDragging: Bool = false
    @State private var rotationAngle: CGFloat = 0
    @State private var elementID: UUID = .init()

    var body: some View {
//        GeometryReader { proxy in
            let rowHeight: CGFloat = 150
            let space: DSSpace = .horizontal
            let matrix = calculateRows(widgets)

            Grid(
                horizontalSpacing: space.rawValue,
                verticalSpacing: space.rawValue
            ) {
                ForEach(matrix, id: \.id) { row in
                    GridRow {
                        ForEach(row.data, id: \.widget.config.id) { widgetViewData in
                            let shakeAnimation = Animation.easeInOut(duration: Constants.animationDuration).repeatForever(autoreverses: true)

                            widgetElement(widgetViewData.widget)
                                .gridCellColumns(widgetViewData.columns)
//                                .rotationEffect(editMode ? .degrees(5) : .zero)
                                .rotationEffect(.degrees(5))
//                                .background(editMode ? Color.red : Color.orange)
                                .animation(shakeAnimation, value: editMode)
                        }
                    }
                    .frame(height: rowHeight)
                }
            }
            .padding(.horizontal, space: space)
//        }
    }

    private func calculateRows(
        _ widgets: [WidgetData]
    ) -> [RowData] {
        var matrix: [RowData] = [(UUID(), [])]

        let columnsLimit = 3
        var columnsCount: Int = .zero
        var currentRow: Int = .zero

        for widget in widgets {
            let (columns, rows) = WidgetSize.units(for: widget.config.uiType, entity: widget.entity)
            columnsCount += columns

            if columnsCount > columnsLimit {
                columnsCount = columns
                currentRow += 1
                matrix.append((UUID(), []))
            }

            matrix[currentRow].data.append((widget, columns, rows))
        }
        return matrix
    }

//    widgetElement(widgetViewData.widget)
//        .gridCellColumns(widgetViewData.columns)
//        .padding(.leading, -Constants.removeIconWidth / 3)
//        .padding(.top, -Constants.removeIconHeight / 3)
//        .rotationEffect(.degrees(editMode ? Constants.shakeAnimationAngle : .zero))
//        .animation(editMode ? shakeAnimation : .default, value: editMode)
//        .onDrop(of: [.text], delegate: WidgetDropDelegate(
//            widget: widgetViewData.widget,
//            widgets: $widgets,
//            draggedItem: $draggedItem,
//            isDragging: $isDragging,
//            didUpdateOrder: didUpdateWidgetsOrder
//        ))
//        .onDrag {
//            draggedItem = widgetViewData.widget
//            editMode = true
//            return NSItemProvider(object: widgetViewData.widget.config.id as NSString)
//        } preview: { EmptyView() }

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
            lightWidgetView(widget.config, light)
        case let fan as FanEntity:
            fanWidgetView(widget.config, fan)
        default:
            UnsupportedWidgetView(entity: widget.entity)
        }
    }

    @ViewBuilder
    private func lightWidgetView(
        _ widgetConfig: WidgetConfig,
        _ lightEntity: LightEntity
    ) -> some View {
        switch widgetConfig.uiType {
        default:
            LightWidgetView(lightEntity: lightEntity) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateLightState($0, $1)
            }
        }
    }

    @ViewBuilder
    private func fanWidgetView(
        _ widgetConfig: WidgetConfig,
        _ fanEntity: FanEntity
    ) -> some View {
        switch widgetConfig.uiType {
        case FanSliderWidgetView.uniqueID:
            FanSliderWidgetView(fanEntity: fanEntity) {
                didClickUpdateFanState($0, $1)
            }
        default:
            FanWidgetView(fanEntity: fanEntity) {
                didClickUpdateFanState($0, $1)
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
            didClickUpdateLightState: { _, _ in },
            didClickUpdateFanState: { _, _ in }
        )
    }
}
#endif
