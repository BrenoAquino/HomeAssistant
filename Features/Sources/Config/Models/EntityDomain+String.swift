//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.EntityDomain {
    var name: String {
        String(describing: self)
    }
}
