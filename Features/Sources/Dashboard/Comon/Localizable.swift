//
//  Localizable.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

enum Localizable: String {
    case hiThere = "hi_there"
    case welcome
}

extension Localizable {
    var value: String {
        NSLocalizedString(rawValue, bundle: .module, comment: "")
    }
}

extension Text {

    init(localizable: Localizable) {
        self = Text(localizable.value)
    }
}
