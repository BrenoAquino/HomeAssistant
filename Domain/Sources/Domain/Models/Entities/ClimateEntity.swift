//
//  ClimateEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class ClimateEntity: Entity {

    public var hvac: HVAC?
    public let temperature: Temperature?

    public init(
        id: String,
        name: String,
        state: EntityState,
        hvacModes: [String]? = nil,
        currentHvacMode: String? = nil,
        minimumTemperature: Double? = nil,
        maximumTemperature: Double? = nil,
        targetTemperature: Double? = nil,
        currentTemperature: Double? = nil,
        stepTemperature: Double? = nil
    ) {
        self.hvac = HVAC(current: currentHvacMode, allModes: hvacModes)
        self.temperature = Temperature(
            minimum: minimumTemperature,
            maximum: maximumTemperature,
            target: targetTemperature,
            current: currentTemperature,
            step: stepTemperature
        )
        super.init(id: id, name: name, domain: .climate, state: state)
    }

    public class HVAC {

        public var current: String?
        public let allModes: [String]?

        init(current: String?, allModes: [String]?) {
            self.current = current
            self.allModes = allModes
        }
    }

    public class Temperature {

        public let minimum: Double?
        public let maximum: Double?
        public var target: Double?
        public var current: Double?
        public let step: Double?

        init(minimum: Double?, maximum: Double?, target: Double?, current: Double?, step: Double?) {
            self.minimum = minimum
            self.maximum = maximum
            self.target = target
            self.current = current
            self.step = step
        }
    }
}
