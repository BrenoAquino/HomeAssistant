//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import UIKit

extension UIColor {

    convenience init(adaptiveColor: AdaptiveColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return adaptiveColor.uiColor.light
            case .dark:
                return adaptiveColor.uiColor.dark
            case .unspecified:
                return adaptiveColor.uiColor.light
            @unknown default:
                return adaptiveColor.uiColor.light
            }
        }
    }
}
