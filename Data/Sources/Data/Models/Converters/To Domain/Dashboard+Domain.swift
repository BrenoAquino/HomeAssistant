//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

extension Dashboard {

    func toDomain() -> Domain.Dashboard {
        return Domain.Dashboard(name: self.name, icon: self.icon, entities: self.entities)
    }
}
