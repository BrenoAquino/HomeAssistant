//
//  Entity.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol Entity: Hashable {

    var id: String { get }
    var name: String { get }
    var domain: EntityDomain { get }
    var state: EntityState { get set }
}

extension Entity {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
