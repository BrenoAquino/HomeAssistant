//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import DesignSystem
import SwiftUI

extension View {
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
//            .overlay(self.blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}

struct LightView<T: LightEntityUI>: View {

    @Binding var entity: T

    var body: some View {
        ZStack {
            content
            GeometryReader { proxy in
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: proxy.size.width / 2, height: 50)
                    .offset(x: proxy.size.width / 4)
                    .shadow(color: .orange, radius: 10 / 3, x: 1, y: 20)
                    .shadow(color: .orange, radius: 10 / 3, x: 1, y: 20)
                    .shadow(color: .orange, radius: 10 / 3, x: 1, y: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.vertical, space: .normal)
        .padding(.horizontal, space: .smallL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: .hard))
        .onTapGesture {
            entity.lightState = entity.lightState.toggle()
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            let radius: CGFloat = 36
            let color = entity.isOn ? SystemColor.orange : .clear
            Image(systemName: entity.icon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glow(color: color, radius: radius)
//                .blur(radius: radius / 6)
//                .shadow(color: color, radius: radius / 3)
//                .shadow(color: color, radius: radius / 3)
//                .shadow(color: color, radius: radius / 3)
            Spacer()
            lightState
        }
    }

    private var lightState: some View {
        HStack(spacing: .smallS) {
            lightInfo
            Spacer()
            Toggle("", isOn: .init(
                get: { entity.lightState == .on },
                set: { entity.lightState = $0 ? .on : .off }
            ))
            .labelsHidden()
            .scaleEffect(0.6)
            .controlSize(.mini)
        }
    }

    private var lightInfo: some View {
        VStack(spacing: .smallS) {
            Text(entity.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(SystemColor.label)

            Text(entity.lightState.rawValue)
                .font(.caption2)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(SystemColor.secondaryLabel)
        }
    }
}

#if DEBUG
struct LightView_Preview: PreviewProvider {

    struct LightEntityMock: LightEntityUI {

        let name: String
        let icon: String = "lamp.ceiling.inverse"
        var lightState: LightStateUI
    }

    private static var entityOn = LightEntityMock(name: "Trilho", lightState: .on)
    private static var entityOff = LightEntityMock(name: "Trilho", lightState: .off)

    static var previews: some View {
        let size: CGFloat = 150

        HStack(spacing: .bigL) {
            LightView(entity: .init(get: {
                entityOn
            }, set: { newValue in
                entityOn = newValue
            }))
            .frame(width: size, height: size)

            LightView(entity: .init(get: {
                entityOff
            }, set: { newValue in
                entityOff = newValue
            }))
            .frame(width: size, height: size)
        }
    }
}
#endif
