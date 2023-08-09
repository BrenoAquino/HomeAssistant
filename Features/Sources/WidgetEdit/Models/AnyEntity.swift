//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import Foundation

struct AnyEntity {

    let entity: any Entity
}

extension AnyEntity: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(entity.id)
    }

    static func == (lhs: AnyEntity, rhs: AnyEntity) -> Bool {
        lhs.entity.id == rhs.entity.id
    }
}
