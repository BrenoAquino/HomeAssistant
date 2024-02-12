//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

enum Localizable: String, CommonLocalizable {
    case tryAgain = "try_again"
    case connectionError = "connection_error"
}

extension Localizable {
    var bundle: Bundle { .module }
}
