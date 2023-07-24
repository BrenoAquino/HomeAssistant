//
//  GenericEntity+Domain.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Domain
import Foundation

extension GenericEntity {

    func toDomain() throws -> any Domain.Entity {
        let domain = try Domain.EntityDomain(id: id)
        switch domain {
        case .light:
            return Domain.LightEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off
            )

        case .switch:
            return Domain.SwitchEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off
            )

        case .fan:
            return Domain.FanEntity(
                id: id,
                name: attributes.name,
                percentageStep: attributes.percentageStep,
                percentage: attributes.currentPercentage,
                state: .init(rawValue: state) ?? .off
            )

        case .climate:
            return Domain.ClimateEntity(
                id: id,
                name: attributes.name,
                state: .init(rawValue: state) ?? .off,
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
