//
//  ServerConfig.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct ServerConfig: Decodable {

    let latitude: Double
    let longitude: Double
    let elevation: Double
    let locationName: String
    let timeZone: String
    let version: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case latitude, longitude, elevation, version, state
        case timeZone = "time_zone"
        case locationName = "location_name"
    }

    struct UnitSystem: Decodable {

        let length: String
        let accumulatedPrecipitation: String
        let pressure: String
        let temperature: String
        let volume: String
        let windSpeed: String

        enum CodingKeys: String, CodingKey {
            case length, pressure, temperature, volume
            case accumulatedPrecipitation = "accumulated_precipitation"
            case windSpeed = "wind_speed"
        }
    }
}
