//
//  File.swift
//  
//
//  Created by Breno Aquino on 27/07/23.
//

import Foundation
import Domain

extension FanEntity {
    var isOn: Bool { state == .on }
    var invertedState: FanEntity.State { state == .on ? .off : .on }
    var onIcon: String { "fanblades.fill" }
    var offIcon: String { "fanblades.slash.fill" }
    var icon: String { isOn ? onIcon : offIcon }
}
