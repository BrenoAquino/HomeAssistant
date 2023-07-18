//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DashboardLocalDataSource {

    func dashboards() async throws -> [Dashboard]
    func save(dashboards: [Dashboard]) async throws
}
