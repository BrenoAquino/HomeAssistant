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

struct EntitiesView: View {

    @Binding var editMode: Bool
    @Binding var entities: [any Entity]

    let didUpdateOrder: (_ entities: [any Entity]) -> Void
    let didClickRemoveEntity: (_ entity: any Entity) -> Void
    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void

    @State private var draggedEntity: (any Entity)?
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let numberOfElementsInRow: Int = 3
            let space = DSSpace.horizontal.rawValue
            let totalSpace = space * (CGFloat(numberOfElementsInRow) + 1)
            let size = (proxy.size.width - totalSpace) / CGFloat(numberOfElementsInRow)
            let columns = [GridItem](
                repeating: .init(.fixed(size), spacing: space),
                count: numberOfElementsInRow
            )

            LazyVGrid(columns: columns, spacing: space) {
                ForEach(Array(entities.enumerated()), id: \.element.id) { index, entity in
                    let shakeAnimation = Animation.easeInOut(duration: Constants.animationDuration).repeatForever(autoreverses: true)
                    let isCurrentElementDragging = draggedEntity?.id == entity.id
                    let shouldHide = isDragging && isCurrentElementDragging

                    element(entity)
                        .padding(.leading, -Constants.removeIconWidth / 3)
                        .padding(.top, -Constants.removeIconHeight / 3)
                        .frame(height: size)
                        .rotationEffect(.degrees(editMode ? Constants.shakeAnimationAngle : .zero))
                        .animation(editMode ? shakeAnimation : .default, value: editMode)
                        .opacity(shouldHide ? .leastNonzeroMagnitude : 1)
                        .onDrop(of: [.text], delegate: EntityDropDelegate(
                            entity: entity,
                            entities: $entities,
                            draggedEntity: $draggedEntity,
                            isDragging: $isDragging,
                            didUpdateOrder: didUpdateOrder
                        ))
                        .onDrag {
                            draggedEntity = entity
                            editMode = true
                            return NSItemProvider(object: entity.id as NSString)
                        }
                }
            }
        }
    }

    private func element(
        _ entity: any Entity
    ) -> some View {
        ZStack(alignment: .topLeading) {
            entityView(entity)
                .padding(.leading, Constants.removeIconWidth / 3)
                .padding(.top, Constants.removeIconHeight / 3)

            SystemImages.remove
                .imageScale(.large)
                .frame(width: Constants.removeIconWidth, height: Constants.removeIconHeight)
                .opacity(editMode ? 1 : 0)
                .animation(.default, value: editMode)
                .onTapGesture {
                    didClickRemoveEntity(entity)
                }
        }
    }

    @ViewBuilder
    private func entityView(
        _ entity: any Entity
    ) -> some View {
        switch entity {
        case let light as LightEntity:
            LightView(lightEntity: light) {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                didClickUpdateLightState($0, $1)
            }
        default:
            UnsupportedView(
                name: entity.name,
                domain: entity.domain.rawValue
            )
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
                let aux = entities[fromIndex]
                entities[fromIndex] = entities[toIndex]
                entities[toIndex] = aux
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

    static var previews: some View {

        EntitiesView(
            editMode: .constant(false),
            entities: .constant(EntityMock.all),
            didUpdateOrder: { _ in },
            didClickRemoveEntity: { _ in },
            didClickUpdateLightState: { _, _ in }
        )
    }
}
#endif
