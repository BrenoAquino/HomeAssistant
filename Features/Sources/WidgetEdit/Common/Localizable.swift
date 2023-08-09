//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {

    case update
    case description
    case updateError = "update_error"
    case widgetName = "widget_name"
    case widgetTitle = "widget_title"
    case entitySelectionTitle = "entity_selection_title"
    case entitySelectionDescription = "entity_selection_description"
    case entitiesHint = "entities_hint"
    case entitiesSearchExample = "entities_search_example"
}

extension Localizable {
    var bundle: Bundle { .module }
}
