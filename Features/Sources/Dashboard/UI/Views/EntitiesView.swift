//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import DesignSystem
import Domain
import SwiftUI

struct EntitiesView: View {

    let entities: [any Entity]
    let didClickUpdateLightState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void

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
                    Group {
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
                    .frame(height: size)
                }
            }
        }
    }
}

#if DEBUG
import Preview

struct EntitiesView_Preview: PreviewProvider {

    static var previews: some View {

        EntitiesView(
            entities: EntityMock.all,
            didClickUpdateLightState: { _, _ in }
        )
    }
}
#endif
