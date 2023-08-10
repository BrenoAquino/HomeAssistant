//
//  File.swift
//  
//
//  Created by Breno Aquino on 06/08/23.
//

import DesignSystem
import SwiftUI

extension WidgetView {

    func setupSizeAndTag(unitSize: CGFloat) -> some View {
        self
            .frame(width: unitSize * CGFloat(Self.units.columns))
            .frame(height: unitSize * CGFloat(Self.units.rows))
            .tag(Self.uniqueID)
    }
}
