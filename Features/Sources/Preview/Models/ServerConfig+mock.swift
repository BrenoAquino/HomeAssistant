//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

//#if DEBUG || PREVIEW
import Domain
import Foundation

public extension ServerConfig {
    static let mock = ServerConfig(
        locationName: "Home",
        state: .online
    )
}
//#endif
