//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DashboardService {

    var dashboards: Set<Dashboard> { get }

    func add(dashboard: Dashboard)
    func delete(dashboardName: String)
}
