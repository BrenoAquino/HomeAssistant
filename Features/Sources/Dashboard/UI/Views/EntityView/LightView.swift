//
//  LightView.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import DesignSystem
import SwiftUI

struct LightView: View {

    @Binding var entity: LightEntityUI

    var body: some View {
        content
            .padding(.vertical, space: .normal)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                SystemColor.orange
                    .blur(radius: 50)
                    .opacity(entity.isOn ? 1 : 0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(SystemColor.gray3, lineWidth: 1)
                    .opacity(entity.isOn ? 0 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: .hard))
            .contentShape(Rectangle())
            .onTapGesture {
                entity.lightState = entity.lightState.toggle()
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

        let name: String
        let icon: String = "lamp.ceiling.inverse"
        var lightState: LightStateUI
    }

    private static var entityOn = LightEntityMock(name: "Luz Jardim Direita", lightState: .on)
    private static var entityOff = LightEntityMock(name: "Luz Jardim Direita", lightState: .off)

    static var previews: some View {
        let size: CGFloat = 150

        NavigationView {
            DashboardView(viewModel: .init(
                dashboardService: DashboardServiceMock(),
                entityService: EntityServiceMock()
            ))
        }

        HStack(spacing: .bigL) {
            LightView(entity: .init(get: {
                entityOn
            }, set: { newValue in
//                entityOn = newValue
            }))
            .frame(width: size, height: size)

            LightView(entity: .init(get: {
                entityOff
            }, set: { newValue in
//                entityOff = newValue
            }))
            .frame(width: size, height: size)
        }
    }
}
#endif
