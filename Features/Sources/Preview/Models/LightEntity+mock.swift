//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

public extension Domain.LightEntity {
    static let mockMainLight: Self = .init(
        id: "light.main_light",
        name: "Main Light",
        state: .on
    )

    static let mockLedDeskLight: Self = .init(
        id: "light.led_desk",
        name: "Led Desk",
        state: .off
    )

    static let mockLedCeilingLight: Self = .init(
        id: "light.led_ceiling",
        name: "Led Ceiling",
        state: .on
    )

    static let mockLightGarage: Self = .init(
        id: "light.garage",
        name: "Garage Light",
        state: .on
    )
}
//#endif
