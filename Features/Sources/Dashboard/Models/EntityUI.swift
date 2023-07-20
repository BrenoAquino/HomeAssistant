//
//  File.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Foundation
import Domain

protocol LightEntityUI {

    var name: String { get }
    var icon: String { get }
    var isOn: Bool { get }
}

extension LightEntity: LightEntityUI {

    var icon: String { domain.icon }
    var isOn: Bool { state == .on }
}
