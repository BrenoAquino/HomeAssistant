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
    var selectedIndex: Int
    var iconDidSelect: (_ icon: IconUI, _ index: Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: .smallM) {
                ForEach(Array(icons.enumerated()), id: \.element.id) { offset, iconUI in
                    iconElement(iconUI, offset)
                        .onTapGesture { iconDidSelect(iconUI, offset) }
                }
            }
            .padding(.horizontal, space: .smallL)
        }
    }

    @ViewBuilder func iconElement(
        _ iconUI: IconUI,
        _ offset: Int
    ) -> some View {
        let isSelected = offset == selectedIndex

        Image(systemName: iconUI.name)
            .foregroundColor(isSelected ? SystemColor.background : SystemColor.label)
            .frame(width: 50, height: 50)
            .background(isSelected ? SystemColor.label : SystemColor.background)
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(
                        isSelected ? SystemColor.background : SystemColor.gray3,
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
        NavigationView {
            IconsCarouselView(
                icons: IconUI.list,
                selectedIndex: 0,
                iconDidSelect: { _, _ in}
            )
        }
    }
}
#endif
