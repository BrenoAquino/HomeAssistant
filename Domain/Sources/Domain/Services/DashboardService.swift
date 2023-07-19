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
}

public protocol DashboardService {

    var dashboards: CurrentValueSubject<[Dashboard], Never> { get }

    func persist() async throws

    func add(dashboard: Dashboard) throws
    func delete(dashboardName: String)
    func addEntity(_ entity: Entity, dashboardName: String)
    func addEntities(_ entities: [Entity], dashboardName: String)
    func removeEntity(_ entityID: String, dashboardName: String)
    func removeEntities(_ entityIDs: [String], dashboardName: String)
}
