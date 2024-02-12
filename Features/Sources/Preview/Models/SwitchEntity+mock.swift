//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

extension Domain.SwitchEntity {
    static let mockCoffeeMachine: Self = .init(
        id: "switch.coffee_machine",
        name: "Coffee Machine",
        state: .off
    )
}
//#endif
