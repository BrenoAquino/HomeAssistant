//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Domain
import DesignSystem
import SwiftUI

struct LightView: View {

    let lightEntity: LightEntity
    let updateState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void

    var body: some View {
        content
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundEffect)
            .clipShape(RoundedRectangle(cornerRadius: .hard))
            .contentShape(Rectangle())
            .shadow(radius: .veryEasy, color: .black.opacity(0.2))
            .onTapGesture {
                updateState(lightEntity, lightEntity.invertedState)
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            lightState
                .frame(maxWidth: .infinity, alignment: .topLeading)
            lightInfo
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
    }

    private var backgroundEffect: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(lightEntity.isOn ? DSColor.activated : DSColor.deactivated)
    }

    private var lightState: some View {
        HStack(spacing: .smallS) {
            Image(systemName: lightEntity.icon)
                .foregroundColor(.white)
                .padding()
                .background(lightEntity.isOn ? DSColor.orange : DSColor.gray)
                .clipShape(Circle())
        }
    }

    private var lightInfo: some View {
        Text(lightEntity.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(lightEntity.isOn ? .black : DSColor.label)
    }
}

#if DEBUG
import Preview

struct LightView_Preview: PreviewProvider {

    private static var entityOn = LightEntity(id: "lgl", name: "Left Garden Led", state: .on)
    private static var entityOff = LightEntity(id: "rgl", name: "Right Garden Led", state: .off)

    static var previews: some View {
        let size: CGFloat = 150

        HStack(spacing: .bigL) {
            LightView(lightEntity: entityOn, updateState: { _, newState in entityOn.state = newState })
                .frame(width: size, height: size)

            LightView(lightEntity: entityOff, updateState: { _, newState in entityOn.state = newState })
                .frame(width: size, height: size)
        }
    }
}
#endif
