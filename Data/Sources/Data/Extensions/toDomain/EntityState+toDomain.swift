//
//  GenericEntity+Domain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Common
import Domain
import Foundation

extension GenericEntity {
    func toDomain() throws -> any Domain.Entity {
        switch try EntityDomain(entityID: id) {
        case .light:
            return Domain.LightEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off // FIXME: Remove this init
            )

        case .switch:
            return Domain.SwitchEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off // FIXME: Remove this init
            )

        case .fan:
            return Domain.FanEntity(
                id: id,
                name: attributes.name,
                percentageStep: attributes.percentageStep,
                percentage: attributes.currentPercentage,
                state: .init(rawValue: state) ?? .off // FIXME: Remove this init
            )

        case .climate:
            return Domain.ClimateEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off, // FIXME: Remove this init
                hvacModes: attributes.hvacModes,
                currentHvacMode: attributes.currentHvac,
                minimumTemperature: attributes.minTemperature,
                maximumTemperature: attributes.maxTemperature,
                targetTemperature: attributes.targetTemperature,
                currentTemperature: attributes.currentTemperature,
                stepTemperature: attributes.temperatureStep
            )
        }
    }
}
