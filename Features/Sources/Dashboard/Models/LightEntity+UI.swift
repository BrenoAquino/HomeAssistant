//
//  File.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation
import Domain

extension LightEntity {
    var isOn: Bool { state == .on }
    var invertedState: LightEntity.State { state == .on ? .off : .on }
}
