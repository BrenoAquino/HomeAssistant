//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

enum DashboardServiceError: Error {
    case dashboardAlreadyExists
    case dashboardDoesNotExist
}

public protocol DashboardService: ObservableObject {

    var dashboards: [Dashboard] { get set }

    func trackDashboards() async throws
    func persist() async throws

    func add(dashboard: Dashboard) throws
    func update(dashboardName: String, dashboard: Dashboard) throws
    func delete(dashboardName: String)
    func updateAll(dashboards: [Dashboard])
}
