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

struct EntitiesWidgetsView: View {

    @Binding var editMode: Bool
    @Binding var entities: [any Entity]

    let didUpdateOrder: (_ entities: [any Entity]) -> Void
    let didClickRemoveEntity: (_ entity: any Entity) -> Void

    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void
    let didClickUpdateFanState: (_ fanEntity: FanEntity, _ newState: FanEntity.State) -> Void

    @State private var draggedEntity: (any Entity)?
    @State private var isDragging: Bool = false

    typealias RowData = (id: UUID, content: [any Entity])

    func calculateRows(
        _ entities: [any Entity],
        _ proxy: GeometryProxy
    ) -> [RowData] {
        var matrix: [RowData] = [(UUID(), [])]

        var columnsCount = 0
        var currentRow = 0

        for entity in entities {
            switch entity {
            case is LightEntity:
                columnsCount += 1
            case is FanEntity:
                columnsCount += 2
            default:
                columnsCount += 1
            }

            if columnsCount > 3 {
                currentRow += 1
                switch entity {
                case is LightEntity:
                    columnsCount = 1
                case is FanEntity:
                    columnsCount = 2
                default:
                    columnsCount = 1
                }
                matrix.append((UUID(), []))
            }

            let _ = print(columnsCount)
            matrix[currentRow].content.append(entity)
        }
        return matrix
    }

    var body: some View {
        GeometryReader { proxy in
            let rowHeight: CGFloat = 150
            Grid(
                horizontalSpacing: DSSpace.horizontal.rawValue,
                verticalSpacing: DSSpace.horizontal.rawValue
            ) {
                let matrix = calculateRows(entities, proxy)
                ForEach(matrix, id: \.id) { row in
                    GridRow {
                        ForEach(row.content, id: \.id) { entity in
                            let elem = entityView(entity)
                            elem.content
                                .gridCellColumns(elem.columns)
                        }
                    }
                    .frame(height: rowHeight)
                }
            }
            .padding(.horizontal, space: .horizontal)
        }
    }

    //    private func element(
    //        _ entity: any Entity
    //    ) -> some View {
    //        ZStack(alignment: .topLeading) {
    //            entityView(entity)
    //                .padding(.leading, Constants.removeIconWidth / 3)
    //                .padding(.top, Constants.removeIconHeight / 3)
    //
    //            SystemImages.remove
    //                .imageScale(.large)
    //                .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
    //                .opacity(editMode ? 1 : 0)
    //                .animation(.default, value: editMode)
    //                .onTapGesture {
    //                    didClickRemoveEntity(entity)
    //                }
    //        }
    //    }

    private func entityView(
        _ entity: any Entity
    ) -> (content: some View, columns: Int, rows: Int) {
        switch entity {
        case let light as LightEntity:
            return (AnyView(LightWidgetView(lightEntity: light) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateLightState($0, $1)
            }), 1, 1)
        case let fan as FanEntity:
            return (AnyView(FanSliderWidgetView(fanEntity: fan) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateFanState($0, $1)
            }), 2, 1)
        default:
            return (AnyView(UnsupportedWidgetView(entity: entity)), 1, 1)
        }
    }

    private struct EntityDropDelegate: DropDelegate {

        let entity: any Entity
        @Binding var entities: [any Entity]
        @Binding var draggedEntity: (any Entity)?
        @Binding var isDragging: Bool
        let didUpdateOrder: (_ entities: [any Entity]) -> Void

        func performDrop(info: DropInfo) -> Bool {
            isDragging = false
            draggedEntity = nil
            didUpdateOrder(entities)
            return true
        }

        func dropEntered(info: DropInfo) {
            isDragging = true
            guard
                let draggedEntity,
                let fromIndex = entities.firstIndex(where: { $0.id == draggedEntity.id }),
                let toIndex = entities.firstIndex(where: { $0.id == entity.id })
            else { return }

            withAnimation(.default) {
                entities.move(
                    fromOffsets: IndexSet(integer: fromIndex),
                    toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                )
            }
        }

        func dropUpdated(info: DropInfo) -> DropProposal? {
            return DropProposal(operation: .move)
        }
    }
}

#if DEBUG
import Preview

struct EntitiesView_Preview: PreviewProvider {

    static let entities: [any Entity] = [
        FanEntity(id: "1", name: "Fan 1", percentageStep: nil, percentage: nil, state: .on),
        LightEntity(id: "2", name: "Light 2", state: .on),
        LightEntity(id: "3", name: "Light 3", state: .on),
        LightEntity(id: "4", name: "Light 4", state: .on),
        FanEntity(id: "5", name: "Fan 5", percentageStep: nil, percentage: nil, state: .on),
        LightEntity(id: "6", name: "Light 6", state: .on),
    ]

    static var previews: some View {

        EntitiesWidgetsView(
            editMode: .constant(false),
            entities: .constant(entities),
            didUpdateOrder: { _ in },
            didClickRemoveEntity: { _ in },
            didClickUpdateLightState: { _, _ in },
            didClickUpdateFanState: { _, _ in }
        )
    }
}
#endif
