//
//  IconsListView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

private enum Constants {

    static let minIconSize: CGFloat = 40
}

struct IconsListView: View {

    let proxy: GeometryProxy
    let icons: [Icon]
    @Binding var selectedIconName: String?

    var body: some View {
        let space: DSSpace = .horizontal
        let columnsNumber = Int((proxy.size.width - space.rawValue) / (Constants.minIconSize + space.rawValue))
        let columnsWidth = (proxy.size.width - CGFloat(columnsNumber + 1) * space.rawValue) / CGFloat(columnsNumber)
        let columns: [GridItem] = .init(repeating: .init(.fixed(columnsWidth), spacing: space.rawValue), count: columnsNumber)

        LazyVGrid(columns: columns, spacing: space.rawValue) {
            ForEach(icons, id: \.name) { icon in
                let isSelected = selectedIconName == icon.name

                Image(systemName: icon.name)
                    .foregroundColor(isSelected ? DSColor.background : DSColor.label)
                    .frame(maxWidth: .infinity)
                    .frame(height: columnsWidth)
                    .background(isSelected ? DSColor.label : DSColor.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: .hard)
                            .stroke(
                                isSelected ? DSColor.background : DSColor.gray3,
                                lineWidth: 1
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: .hard))
                    .onTapGesture {
                        selectedIconName = icon.name
                    }
            }
        }
    }
}

#if DEBUG
import Preview

struct IconsListView_Preview: PreviewProvider {

    static var previews: some View {
        GeometryReader { proxy in
            IconsListView(
                proxy: proxy,
                icons: Icon.list,
                selectedIconName: .init(
                    get: { nil },
                    set: { _ in }
                )
            )
        }
    }
}
#endif
