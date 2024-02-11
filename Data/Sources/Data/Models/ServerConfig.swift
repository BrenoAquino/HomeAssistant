//
//  ServerConfig.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct ServerConfig: Decodable {
    /// Latitude in degree
    let latitude: Double
    /// Longitude in degree
    let longitude: Double
    /// Elevation in degree
    let elevation: Double
    /// Location name
    let locationName: String
    /// Timezone
    let timeZone: String
    /// Home Assistant version
    let version: String
    /// Current server state
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
