//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Domain
import DesignSystem
import SwiftUI

private enum Constants {

    static let backgroundColor = Color.init(red: 0.8, green: 0.8, blue: 0.8)
}

struct LightView: View {

    let lightEntity: LightEntity
    let updateState: (_ lightEntity: LightEntity, _ newState: LightEntity.State) -> Void

    var body: some View {
        content
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundEffect)
//            .background(lightEntity.isOn ? Material.regular : .ultraThinMaterial)
//            .background(DSColor.background)
//            .overlay(
//                RoundedRectangle(cornerRadius: .hard)
//                    .stroke(DSColor.gray3, lineWidth: 1)
//                    .opacity(lightEntity.isOn ? 0 : 1)
//            )
            .clipShape(RoundedRectangle(cornerRadius: .hard))
            .contentShape(Rectangle())
//            .shadow(radius: .easy)
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
            .background(Color.white.opacity(lightEntity.isOn ? 0.8 : 0.15))
            .background(DSColor.gray4)
//            .background(Color.black.opacity(0.5))
    }

    private var lightState: some View {
        HStack(spacing: .smallS) {
            Image(systemName: lightEntity.icon)
                .foregroundColor(.white)
                .padding()
                .background(lightEntity.isOn ? DSColor.orange : DSColor.gray)
                .clipShape(Circle())

//            Text(lightEntity.state.rawValue)
//                .textCase(.uppercase)
//                .foregroundColor(DSColor.secondaryLabel)
//                .font(.subheadline)
//                .padding(.trailing, space: .smallM)
//                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var lightInfo: some View {
        Text(lightEntity.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(lightEntity.isOn ? .black : .white)
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
