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
    case done
    case devices
    case unsupported
    case cancel
    case delete
    case deleteDescription = "delete_description"
    case ok
    case deleteSuccess = "delete_success"
    case lightError = "light_error"
}

extension Localizable {
    var bundle: Bundle { .module }
}
