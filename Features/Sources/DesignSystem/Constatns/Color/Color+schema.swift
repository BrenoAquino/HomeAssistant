//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

extension Color {
    
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
}
