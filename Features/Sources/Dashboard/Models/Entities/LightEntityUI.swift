//
//  File.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Foundation
import Domain

enum LightStateUI: String {
    case on
    case off

    var isOn: Bool { self == .on }
    var inverted: Self { self == .on ? .off : .on }
}

protocol LightEntityUI {

    var name: String { get }
    var icon: String { get }
    var lightState: LightStateUI { get set }
}

extension LightEntity: LightEntityUI {

    var icon: String { domain.icon }
    var lightState: LightStateUI {
        get { state == .on ? .on : .off }
        set { state = newValue == .on ? .on : .off }
    }
}
