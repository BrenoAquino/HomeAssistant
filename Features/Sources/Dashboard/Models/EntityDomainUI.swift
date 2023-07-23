//
//  File.swift
//  
//
//  Created by Breno Aquino on 20/07/23.
//

import Foundation
import Domain

protocol EntityDomainUI {

    var name: String { get }
    var icon: String { get }
}

extension EntityDomain: EntityDomainUI {
    var name: String { String(describing: self) }
}
