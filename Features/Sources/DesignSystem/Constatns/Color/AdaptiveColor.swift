//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import UIKit

public enum AdaptiveColor {

    // MARK: Text
    case primaryText

    // MARK: Background
    case background
}

public extension AdaptiveColor {

    var uiColor: (light: UIColor, dark: UIColor) {
        switch self {
        case .primaryText:
            return (.black, .white)
        case .background:
            return (.white, .black)
        }
    }

    var color: (light: Color, dark: Color) {
        (Color(uiColor: uiColor.light), Color(uiColor: uiColor.dark))
    }
}
