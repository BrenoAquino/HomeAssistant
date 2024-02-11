//
//  DashboardLocalDataSource.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DashboardLocalDataSource {
    /// Retrieves all dashboards, throwing an error if the operation fails
    func dashboards() async throws -> [Dashboard]
    /// Save and replace  all dashboards, throwing an error if the operation fails
    func save(dashboards: [Dashboard]) async throws
}
