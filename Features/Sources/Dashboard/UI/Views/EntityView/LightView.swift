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

    var body: some View {
//        VStack(spacing: .zero) {
//            HStack {
//                lightInfo
//                Spacer()
//            }
//
//            Spacer()
//
//            HStack {
//                Toggle("mini", isOn: .constant(true))
//                    .controlSize(.mini)
//                Toggle("small", isOn: .constant(true))
//                    .controlSize(.small)
//            }
//            .controlSize(.mini)
//
//        }
        Toggle("small", isOn: .constant(true))
            .controlSize(.mini)
//        .padding(.vertical, space: .normal)
//        .padding(.horizontal, space: .smallL)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.thinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: .hard))
    }

    private var lightInfo: some View {
        VStack(alignment: .leading, spacing: .smallM) {
            Image(systemName: entity.icon)
            Text(entity.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(SystemColor.label)
        }
    }
}

#if DEBUG
struct LightView_Preview: PreviewProvider {

    struct LightEntityMock: LightEntityUI {

        let name: String
        let icon: String = "lamp.ceiling.inverse"
        let isOn: Bool
    }

    static var previews: some View {

        Toggle("small", isOn: .constant(true))
            .controlSize(.large)
//        LightView(entity: LightEntityMock(
//            name: "Trilho",
//            isOn: true
//        ))
//        .frame(width: 150, height: 150)
    }
}
#endif
