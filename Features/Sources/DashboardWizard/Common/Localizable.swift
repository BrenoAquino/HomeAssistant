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
    case dashboardEdit = "dashboard_edit"
    case dashboardDescription = "dashboard_description"
    case name
    case nameHint = "name_hint"
    case icon
    case iconHint = "icon_hint"
    case iconExample = "icon_example"
    case entities
    case entitiesHint = "entities_hint"
    case create
    case update
    case missingNameError = "missing_name_error"
    case nameAlreadyExistsError = "name_already_exists_error"
    case missingIconError = "missing_icon_error"
    case invalidNumberOfColumnsError = "invalid_number_columns_error"
    case unknownError = "unknown_error"
    case columns
    case columnsDescription = "columns_description"
}

extension Localizable {
    var bundle: Bundle { .module }
}
