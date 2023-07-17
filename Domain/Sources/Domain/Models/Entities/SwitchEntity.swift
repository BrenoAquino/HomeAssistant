//
//  SwitchEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class SwitchEntity: Entity {

    public init(id: String, name: String, state: EntityState) {
        super.init(id: id, name: name, domain: .switch, state: state)
    }
}
