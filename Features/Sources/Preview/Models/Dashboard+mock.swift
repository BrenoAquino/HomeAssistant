//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

extension Domain.Dashboard {
    static let mockBedroom: Self = .init(
        name: "Bedroom",
        icon: "bed.double",
        columns: 3,
        widgetConfigs: [
            .mock(entity: LightEntity.mockLedDeskLight),
            .mock(entity: LightEntity.mockLedCeilingLight),
            .mock(entity: FanEntity.mock),
            .mock(entity: LightEntity.mockMainLight),
        ]
    )

    static let mockLiving: Self = .init(
        name: "Living Room",
        icon: "sofa",
        columns: 3,
        widgetConfigs: [
            .mock(entity: ClimateEntity.mock),
        ]
    )

    static let mockKitchen: Self = .init(
        name: "Kitchen",
        icon: "refrigerator",
        columns: 3,
        widgetConfigs: [
            .mock(entity: SwitchEntity.mockCoffeeMachine),
        ]
    )

    static let mockGarden: Self = .init(
        name: "Garden",
        icon: "tree",
        columns: 3,
        widgetConfigs: [
            .mock(entity: LightEntity.mockMainLight),
            .mock(entity: FanEntity.mock),
        ]
    )

    static let mockSecurity: Self = .init(
        name: "Security",
        icon: "light.beacon.max",
        columns: 3,
        widgetConfigs: [
            .mock(entity: LightEntity.mockMainLight),
        ]
    )
}
//#endif
