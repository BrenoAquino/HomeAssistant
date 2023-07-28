//
//  UnsupportedView.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import DesignSystem
import SwiftUI

struct UnsupportedWidgetView: EntityWidgetView {

    let uniqueID: String = "unsupported"
    let xUnit: Int = 1
    let yUnit: Int = 1

    let entity: any Entity

    var body: some View {
        VStack {
            Text(entity.name)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .foregroundColor(DSColor.label)
                .font(.headline)
                .frame(maxHeight: .infinity, alignment: .center)

            Localizable.unsupported.text
                .textCase(.uppercase)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .foregroundColor(DSColor.secondaryLabel)
                .font(.subheadline)
        }
        .padding(.vertical, space: .smallL)
        .padding(.horizontal, space: .smallL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColor.gray5)
        .clipShape(RoundedRectangle(cornerRadius: .hard))
        .contentShape(Rectangle())
        .opacity(0.4)
    }
}

#if DEBUG
import Preview

struct UnsupportedWidgetView_Preview: PreviewProvider {

    static var previews: some View {
        let size: CGFloat = 150
        
        UnsupportedWidgetView(entity: EntityMock.climate)
            .frame(width: size, height: size)
    }
}
#endif
