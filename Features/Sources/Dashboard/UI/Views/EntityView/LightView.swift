//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import DesignSystem
import SwiftUI

struct LightView: View {

    let entity: LightEntityUI
    let updateState: (_ lightEntityUI: LightEntityUI, _ newState: LightStateUI) -> Void

    var body: some View {
        content
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                SystemColor.orange
                    .blur(radius: 50)
                    .opacity(entity.lightState.isOn ? 1 : 0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(SystemColor.gray3, lineWidth: 1)
                    .opacity(entity.lightState.isOn ? 0 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: .hard))
            .contentShape(Rectangle())
            .onTapGesture {
                updateState(entity, entity.lightState.inverted)
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

    private var lightState: some View {
        HStack(spacing: .smallS) {
            Image(systemName: entity.icon)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(entity.lightState.rawValue.uppercased())
                .foregroundColor(SystemColor.secondaryLabel)
                .font(.subheadline)
                .padding(.trailing, space: .smallM)
        }
    }

    private var lightInfo: some View {
        Text(entity.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(SystemColor.label)

//        VStack(spacing: .smallS) {
//            Text(entity.name)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.subheadline)
//                .fontWeight(.semibold)
//                .foregroundColor(SystemColor.label)
//
//            Text(entity.lightState.rawValue)
//                .font(.caption2)
//                .fontWeight(.regular)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundColor(SystemColor.secondaryLabel)
//        }
    }
}

#if DEBUG
import Preview

struct LightView_Preview: PreviewProvider {

    struct LightEntityMock: LightEntityUI {

        let id: String = ""
        let name: String
        let icon: String = "lamp.ceiling.inverse"
        var lightState: LightStateUI
    }

    private static var entityOn = LightEntityMock(name: "Luz Jardim Direita", lightState: .on)
    private static var entityOff = LightEntityMock(name: "Luz Jardim Direita", lightState: .off)

    static var previews: some View {
        let size: CGFloat = 150

        HStack(spacing: .bigL) {
            LightView(entity: entityOn, updateState: { _, newState in entityOn.lightState = newState })
                .frame(width: size, height: size)
            
            LightView(entity: entityOff, updateState: { _, newState in entityOn.lightState = newState })
                .frame(width: size, height: size)
        }
    }
}
#endif
