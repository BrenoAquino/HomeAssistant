//
//  DashboardRepository.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DashboardRepository {
    /// Retrieve all saved dashboards
    func fetchDashboards() async throws -> [Dashboard]
    /// Save all dashboard and its configuration
    func save(dashboards: [Dashboard]) async throws
}
