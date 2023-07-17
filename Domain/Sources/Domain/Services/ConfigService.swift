//
//  ConfigService.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public protocol ConfigService {

    func config() async throws -> ServerConfig
}
