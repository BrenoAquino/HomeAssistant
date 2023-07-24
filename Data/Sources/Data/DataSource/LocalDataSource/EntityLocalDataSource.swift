//
//  EntityLocalDataSource.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Foundation

public protocol EntityLocalDataSource {

    func hiddenEntityIDs() async throws -> [String]
    func save(hiddenEntityIDs: [String]) async throws
}
