//
//  GenericEntity.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct GenericEntity: Decodable {
    /// Entity ID
    public let id: String
    /// Current entity state
    public let state: String
    /// Metadata regarding the entity
    public let attributes: Attributes

    enum CodingKeys: String, CodingKey {
        case state, attributes
        case id = "entity_id"
    }

    public struct Attributes: Decodable {
        /// Entity name
        public let name: String
        /// Climate available modes
        public let hvacModes: [String]?
        /// Climate's fan available modes
        public let fanModes: [String]?
        /// Climate's minimum temperature
        public let minTemperature: Double?
        /// Climate's maximum temperature
        public let maxTemperature: Double?
        /// Climate's target temperature
        public let targetTemperature: Double?
        /// Climate's temperature step
        public let temperatureStep: Double?
        /// Climate current mode
        public let currentHvac: String?
        /// Climate's fan current mode
        public let currentFanModel: String?
        /// Climate current temperature
        public let currentTemperature: Double?
        /// Fan current speed (percentage)
        public let currentPercentage: Double?
        /// Fan's speed step  (percentage)
        public let percentageStep: Double?

        enum CodingKeys: String, CodingKey {
            case name = "friendly_name"
            case hvacModes = "hvac_modes"
            case fanModes = "fan_modes"
            case minTemperature = "min_temp"
            case maxTemperature = "max_temp"
            case targetTemperature = "temperature"
            case temperatureStep = "target_temp_step"
            case currentHvac = "hvac_action"
            case currentFanModel = "fan_mode"
            case currentTemperature = "current_temperature"
            case currentPercentage = "percentage"
            case percentageStep = "percentage_step"
        }
    }
}
