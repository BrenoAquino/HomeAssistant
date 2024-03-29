//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Domain
import SwiftUI

private enum Constants {

    static let shadowOpacity: CGFloat = 0.2
    static let strokeWidth: CGFloat = 1
    static let strokeOpacity: CGFloat = 0.5
}

public struct LightWidgetView: WidgetView {

    public static let uniqueID: String = "default"
    public static let units: (columns: Int, rows: Int) = (1, 1)

    let customInfo: WidgetCustomInfo
    let lightEntity: LightEntity
    let updateState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void

    public init(
        customInfo: WidgetCustomInfo,
        lightEntity: LightEntity,
        updateState: @escaping (_ entity: LightEntity, _ newState: LightEntity.State) -> Void
    ) {
        self.customInfo = customInfo
        self.lightEntity = lightEntity
        self.updateState = updateState
    }

    public var body: some View {
        content
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(lightEntity.isOn ? DSColor.activated : DSColor.deactivated)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: .hard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(DSColor.gray3.opacity(Constants.strokeOpacity), lineWidth: Constants.strokeWidth)
            )
            .contentShape(Rectangle())
            .shadow(radius: .easy, color: .black.opacity(Constants.shadowOpacity))
            .onTapGesture {
                updateState(lightEntity, lightEntity.invertedState)
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Image(systemName: lightEntity.icon)
                .foregroundColor(.white)
                .padding()
                .background(lightEntity.isOn ? DSColor.orange : DSColor.gray)
                .clipShape(Circle())
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Text(customInfo.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(lightEntity.isOn ? .black : DSColor.label)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
}

#if DEBUG
import Preview

struct LightWidgetView_Preview: PreviewProvider {

    private static var entityOn = LightEntity(id: "lgl", name: "Left Garden Led", state: .on)
    private static var entityOff = LightEntity(id: "rgl", name: "Right Garden Led", state: .off)

    static var previews: some View {
        let size: CGFloat = 150

        HStack(spacing: .bigL) {
            LightWidgetView(
                customInfo: .init(title: entityOn.name),
                lightEntity: entityOn,
                updateState: { _, newState in entityOn.state = newState }
            )
            .frame(width: size, height: size)

            LightWidgetView(
                customInfo: .init(title: entityOff.name),
                lightEntity: entityOff,
                updateState: { _, newState in entityOn.state = newState }
            )
            .frame(width: size, height: size)
        }
    }
}
#endif
