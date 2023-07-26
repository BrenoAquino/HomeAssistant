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
    case invalidDashboardOrder
}

public protocol DashboardService {

    var dashboardOrder: CurrentValueSubject<[String], Never> { get }
    var dashboards: CurrentValueSubject<[String : Dashboard], Never> { get }

    func load() async throws
    func persist() async throws

    func add(dashboard: Dashboard) throws
    func delete(dashboardName: String) throws
    func update(dashboardName: String, dashboard: Dashboard) throws

    func update(order: [String]) throws
}

