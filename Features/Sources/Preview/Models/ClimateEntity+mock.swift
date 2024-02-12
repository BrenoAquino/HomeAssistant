//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

extension Domain.ClimateEntity {
    static let mock: Self = .init(
        id: "climate.air_conditioner",
        name: "Air Conditioner",
        state: .cool
    )
}
//#endif
