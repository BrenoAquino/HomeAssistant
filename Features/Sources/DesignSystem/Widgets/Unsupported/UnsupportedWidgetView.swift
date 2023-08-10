//
//  UnsupportedView.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import SwiftUI

public struct UnsupportedWidgetView: WidgetView {

    public static let uniqueID: String = "default"
    public static let units: (columns: Int, rows: Int) = (1, 1)

    let customInfo: WidgetCustomInfo

    public init(customInfo: WidgetCustomInfo) {
        self.customInfo = customInfo
    }

    public var body: some View {
        Text(customInfo.title)
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .foregroundColor(DSColor.label)
            .font(.headline)
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
        
        UnsupportedWidgetView(customInfo: .init(title: EntityMock.climate.name))
            .frame(width: size, height: size)
    }
}
#endif
