//
//  IconsCarouselView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

struct IconsCarouselView: View {

    var icons: [IconUI]
    @Binding var selectedIcon: IconUI?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: .smallM) {
                ForEach(icons, id: \.name) { iconUI in
                    iconElement(iconUI)
                        .onTapGesture {
                            selectedIcon = iconUI
                        }
                }
            }
            .padding(.horizontal, space: .normal)
        }
    }

    @ViewBuilder func iconElement(_ iconUI: IconUI) -> some View {
        let isSelected = selectedIcon?.name == iconUI.name

        Image(systemName: iconUI.name)
            .foregroundColor(isSelected ? DSColor.background : DSColor.label)
            .frame(width: 50, height: 50)
            .background(isSelected ? DSColor.label : DSColor.background)
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(
                        isSelected ? DSColor.background : DSColor.gray3,
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: .hard))
    }
}

#if DEBUG
import Preview

struct IconsCarouselView_Preview: PreviewProvider {

    static var previews: some View {
        IconsCarouselView(
            icons: IconUI.list,
            selectedIcon: .init(
                get: { nil },
                set: { _ in }
            )
        )
    }
}
#endif
