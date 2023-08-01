//
//  File.swift
//  
//
//  Created by Breno Aquino on 31/07/23.
//

//#if DEBUG || PREVIEW
import Combine
import Domain
import Foundation

public enum ConfigMock {

    public static let config = ServerConfig(
        locationName: "Home",
        state: .online
    )
}

public class ConfigServiceMock: Domain.ConfigService {

    public init() {}

    public func config() async throws -> Domain.ServerConfig {
        ConfigMock.config
    }
}
//#endif
