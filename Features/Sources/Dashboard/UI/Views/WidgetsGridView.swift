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

    let widgets: [WidgetData]

    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void
    let didClickUpdateFanState: (_ fanEntity: FanEntity, _ newState: FanEntity.State) -> Void

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
        widgetElement(widget)
            .gridCellColumns(columns)
            .padding(.leading, -Constants.removeIconWidth / 3)
            .padding(.top, -Constants.removeIconHeight / 3)
    }

    @ViewBuilder
    private func widgetElement(
        _ widget: WidgetData
    ) -> some View {
        widgetView(widget)
            .padding(.leading, Constants.removeIconWidth / 3)
            .padding(.top, Constants.removeIconHeight / 3)
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
            UnsupportedWidgetView(customInfo: .init(title: widget.entity.name))
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
                customInfo: widgetData.config.customInfo,
                lightEntity: lightEntity
            ) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateLightState($0, $1)
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
                customInfo: widgetData.config.customInfo,
                fanEntity: fanEntity
            ) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateFanState($0, $1)
            }
        default:
            FanWidgetView(
                customInfo: widgetData.config.customInfo,
                fanEntity: fanEntity
            ) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateFanState($0, $1)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
import Preview

struct WidgetsGridView_Preview: PreviewProvider {

    private static let widgets: [WidgetData] = [
        .init(config: .mock(entity: FanEntity.mock, uiType: "default"), entity: FanEntity.mock),
        .init(config: .mock(entity: LightEntity.mockMainLight, uiType: "default"), entity: LightEntity.mockMainLight),
        .init(config: .mock(entity: LightEntity.mockLedDeskLight, uiType: "default"), entity: LightEntity.mockLedDeskLight),
        .init(config: .mock(entity: LightEntity.mockLedCeilingLight, uiType: "default"), entity: LightEntity.mockLedCeilingLight),
        .init(config: .mock(entity: FanEntity.mock, uiType: "slider"), entity: FanEntity.mock),
        .init(config: .mock(entity: LightEntity.mockLightGarage, uiType: "default"), entity: LightEntity.mockLightGarage),
    ]

    static var previews: some View {

        WidgetsGridView(
            widgets: widgets,
            didClickUpdateLightState: { _, _ in },
            didClickUpdateFanState: { _, _ in }
        )
    }
}
#endif
