//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {

    case empty
}

extension Localizable {
    var bundle: Bundle { .module }
}
