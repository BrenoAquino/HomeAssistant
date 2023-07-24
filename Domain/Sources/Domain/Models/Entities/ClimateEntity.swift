//
//  ClimateEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct ClimateEntity: Entity {

    public enum State: String {
        case cool
        case dry
        case fan
        case off
    }

    public let id: String
    public let name: String
    public let domain: EntityDomain = .climate
    public var state: ClimateEntity.State
    public var hvac: HVAC?
    public var temperature: Temperature?

    public init(
        id: String,
        name: String,
        state: ClimateEntity.State,
        hvacModes: [String]? = nil,
        currentHvacMode: String? = nil,
        minimumTemperature: Double? = nil,
        maximumTemperature: Double? = nil,
        targetTemperature: Double? = nil,
        currentTemperature: Double? = nil,
        stepTemperature: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.state = state
        self.hvac = HVAC(current: currentHvacMode, allModes: hvacModes)
        self.temperature = Temperature(
            minimum: minimumTemperature,
            maximum: maximumTemperature,
            target: targetTemperature,
            current: currentTemperature,
            step: stepTemperature
        )
    }

    public struct HVAC {

        public var current: String?
        public let allModes: [String]?
    }

    public struct Temperature {

        public let minimum: Double?
        public let maximum: Double?
        public var target: Double?
        public var current: Double?
        public let step: Double?
    }
}

// MARK: - Equatable

extension ClimateEntity {
    public static func == (lhs: ClimateEntity, rhs: ClimateEntity) -> Bool {
        lhs.id == rhs.id
    }
}
