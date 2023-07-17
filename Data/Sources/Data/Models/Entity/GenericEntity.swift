//
//  GenericEntity.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public struct GenericEntity: Decodable {

    public let id: String
    public let state: String
    public let attributes: Attributes

    enum CodingKeys: String, CodingKey {
        case state, attributes
        case id = "entity_id"
    }

    public struct Attributes: Decodable {
        public let name: String

        // Climate
        public let hvacModes: [String]?
        public let fanModes: [String]?
        public let minTemperature: Double?
        public let maxTemperature: Double?
        public let targetTemperature: Double?
        public let temperatureStep: Double?
        public let currentHvac: String?
        public let currentFanModel: String?
        public let currentTemperature: Double?

        // Fan
        public let currentPercentage: Double?
        public let percentageStep: Double?

        enum AttributesCodingKeys: String, CodingKey {
            case percentage
            case name = "friendly_name"
            case hvacModes = "hvac_modes"
            case fanModes = "fan_modes"
            case minTemperature = "min_temp"
            case maxTemperature = "max_temp"
            case targetTemperature = "temperature"
            case currentHvac = "hvac_action"
            case currentFanModel = "fan_mode"
            case currentTemperature = "current_temperature"
            case percentageStep = "percentage_step"
        }
    }
}
