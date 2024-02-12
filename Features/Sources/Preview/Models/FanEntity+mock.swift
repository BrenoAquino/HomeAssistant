//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

extension Domain.FanEntity {
    static let mock: Self = .init(
        id: "fan.bedroom_fan",
        name: "Bedroom's Fan",
        percentageStep: 0.2,
        percentage: 0.2,
        state: .on
    )
}
//#endif
