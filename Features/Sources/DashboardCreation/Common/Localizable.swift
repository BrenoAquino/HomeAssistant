//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {

    case dashboardCreation = "dashboard_creation"
    case dashboardDescription = "dashboard_description"
    case name
    case nameHint = "name_hint"
    case icon
    case iconHint = "icon_hint"
    case entities
    case entitiesHint = "entities_hint"
}

extension Localizable {
    var bundle: Bundle { .module }
}
