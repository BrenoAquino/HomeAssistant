//
//  CommonLocalizable.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import SwiftUI


public protocol CommonLocalizable: RawRepresentable<String> {

    var comment: String { get }
    var value: String { get }
    var text: Text { get }
    var bundle: Bundle { get }
}

public extension CommonLocalizable {

    var comment: String { "" }

    var value: String {
        NSLocalizedString(rawValue, bundle: bundle, comment: "")
    }

    var text: Text {
        return Text(value)
    }
}
