//
//  IconsCarouselView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

struct IconsCarouselView: View {

    var icons: [Icon]
    @Binding var selectedIconName: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: .smallM) {
                ForEach(icons, id: \.name) { icon in
                    iconElement(icon)
                        .onTapGesture {
                            selectedIconName = icon.name
                        }
                }
            }
            .padding(.horizontal, space: .horizontal)
        }
    }

    @ViewBuilder func iconElement(_ icon: Icon) -> some View {
        let isSelected = selectedIconName == icon.name

        Image(systemName: icon.name)
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
            icons: Icon.list,
            selectedIconName: .init(
                get: { nil },
                set: { _ in }
            )
        )
    }
}
#endif
