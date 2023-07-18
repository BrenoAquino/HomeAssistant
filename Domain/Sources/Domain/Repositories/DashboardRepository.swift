//
//  DashboardRepository.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DashboardRepository {

    func fetchDashboards() async throws -> [Dashboard]
}
