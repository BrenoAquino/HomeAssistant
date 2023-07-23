//
//  LightEntityUI.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Foundation
import Domain

public enum LightStateUI: String {
    case on
    case off

    var isOn: Bool { self == .on }
    var inverted: Self { self == .on ? .off : .on }
}

public protocol LightEntityUI {

    var id: String { get }
    var name: String { get }
    var icon: String { get }
    var lightState: LightStateUI { get set }
}

extension LightEntity: LightEntityUI {

    public var icon: String { domain.icon }
    public var lightState: LightStateUI {
        get { state == .on ? .on : .off }
        set { state = newValue == .on ? .on : .off }
    }
}
