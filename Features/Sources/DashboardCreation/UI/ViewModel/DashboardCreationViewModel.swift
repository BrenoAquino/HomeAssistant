//
//  DashboardCreationViewModel.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import Combine
import Common
import Domain
import Foundation
import SwiftUI

// MARK: - Interface

public enum DashboardCreationMode: Equatable {

    case creation
    case edit(_ dashboard: Dashboard)
}

public enum DashboardCreationViewModelError: Error {

    case missingName
    case nameAlreadyExists
    case missingIcon
    case missingEntities
}

public protocol DashboardCreationExternalFlow: AnyObject {

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol DashboardCreationViewModel: ObservableObject {

    var delegate: DashboardCreationExternalFlow? { get set }
    var mode: DashboardCreationMode { get }

    var dashboardName: String { get set }

    var icons: [Icon] { get }
    var selectedIconName: String? { get set }
    var iconFilterText: String { get set }

    var entities: [any Entity] { get }
    var selectedEntitiesIDs: Set<String> { get set }
    var entityFilterText: String { get set }

    var domains: [EntityDomain] { get }
    var selectedDomainsNames: Set<String> { get set }

    func close()
    func createOrUpdateDashboard()
}
