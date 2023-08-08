//
//  DashboardCreationViewModel.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import Combine
import Common
import Domain
import Foundation
import SwiftUI

public enum DashboardEditMode: Equatable {

    case creation
    case edit(_ dashboard: Dashboard)
}

public enum DashboardEditViewModelError: Error {

    case missingName
    case nameAlreadyExists
    case missingIcon
    case missingEntities
}

public protocol DashboardEditExternalFlow {

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol DashboardEditViewModel: ObservableObject {

    var delegate: DashboardEditExternalFlow? { get set }
    var mode: DashboardEditMode { get }
    var toastData: DefaultToastDataContent? { get set }

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
