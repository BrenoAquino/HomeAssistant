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
    case invalidNumberOfColumns
}

public protocol DashboardEditExternalFlow {

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol DashboardEditViewModel: ObservableObject {

    var delegate: DashboardEditExternalFlow? { get set }
    var mode: DashboardEditMode { get }
    var toastData: DefaultToastDataContent? { get set }

    var icons: [Icon] { get }
    var iconFilterText: String { get set }

    var dashboardName: String { get set }
    var selectedIconName: String? { get set }
    var columnsNumber: Int { get set }

    func close()
    func createOrUpdateDashboard()
}
