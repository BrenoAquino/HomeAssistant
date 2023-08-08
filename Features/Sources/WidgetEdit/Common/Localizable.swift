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
}

extension Localizable {
    var bundle: Bundle { .module }
}
