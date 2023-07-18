//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

extension Color {
    
    init(adaptiveColor: AdaptiveColor) {
        self.init(UIColor(adaptiveColor: adaptiveColor))
    }
}
