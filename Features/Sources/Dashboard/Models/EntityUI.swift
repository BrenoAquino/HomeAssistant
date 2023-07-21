//
//  File.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Foundation
import Domain

enum LightStateUI: String {
    case on = "ON"
    case off = "OFF"

    func toggle() -> LightStateUI {
        self == .on ? .off : .on
    }
}

protocol LightEntityUI {

    var name: String { get }
    var icon: String { get }
    var lightState: LightStateUI { get set }
}

extension LightEntityUI {
    var isOn: Bool { lightState == .on }
}

extension LightEntity: LightEntityUI {

    var icon: String { domain.icon }
    var lightState: LightStateUI {
        get { state == .on ? .on : .off }
        set { state = newValue == .on ? .on : .off }
    }
}
