//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {

    case devices
    case config
    case entitiesHint = "entities_hint"
}

extension Localizable {
    var bundle: Bundle { .module }
}
