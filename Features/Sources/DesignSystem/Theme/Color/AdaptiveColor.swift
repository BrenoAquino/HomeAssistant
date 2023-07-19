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
//    case secondarySystemBackground
//    case tertiarySystemBackground
//    case systemGroupedBackground
//    case secondarySystemGroupedBackground
//    case tertiarySystemGroupedBackground
}

public extension AdaptiveColor {

    var schema: (light: UIColor, dark: UIColor) {
        switch self {
        case .primaryText:
            return (light: .black, dark: .white)
        case .background:
            return (light: .white, dark: .black)
        }
    }

    var uiColor: UIColor {
        UIColor(light: schema.light, dark: schema.dark)
    }

    var color: Color {
        Color(light: Color(schema.light), dark: Color(schema.dark))
    }
}
