//
//  DashboardService.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Foundation

enum DashboardServiceError: Error {
    /// If the service tries to add an dashboard that already exists (same name)
    case dashboardAlreadyExists
    /// If the service tries to retrieve a dashboard that does not exist
    case dashboardDoesNotExist
    /// If the service tries to save an invalid order (such as invalid order count)
    case invalidDashboardOrder
}

public protocol DashboardService {
    /// Dashboard order
    var dashboardOrder: [String] { get }
    /// An interface to be notified when the dashboard order changes
    var dashboardOrderPublisher: AnyPublisher<[String], Never> { get }
    /// All dashboards
    var dashboards: [String: Dashboard] { get }
    /// An interface to be notified when the value of any dashboard changes
    var dashboardsPublisher: AnyPublisher<[String: Dashboard], Never> { get }
    /// Load all dashboards
    func load() async throws
    /// Add a new dashboard
    func add(dashboard: Dashboard) throws
    /// Delete a dashboard
    func delete(dashboardName: String) throws
    /// Update a dashboard
    func update(dashboardName: String, dashboard: Dashboard) throws
    /// Update dashboards order
    func update(order: [String]) throws
}
