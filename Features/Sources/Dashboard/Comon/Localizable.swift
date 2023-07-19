//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {

    case hiThere = "hi_there"
    case welcome
}

extension Localizable {
    var bundle: Bundle { .module }
}
