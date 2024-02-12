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

public enum DashboardWizardMode: Equatable {
    /// Prepare to create a new dashboard
    case creation
    /// Prepare to edit an existing dashboard
    case edit(_ dashboard: Dashboard)
}

public enum DashboardWizardViewModelError: Error {
    /// Missing dashboard's name
    case missingName
    /// Name already picked
    case nameAlreadyExists
    /// Missing dashboard's icon
    case missingIcon
    /// Invalid number of columns
    case invalidNumberOfColumns
}

public protocol DashboardWizardExternalFlow {
    /// When the user finish the creation/update
    func didFinish() -> Void
    /// When the user cancels the operation, closing the feature
    func didClose() -> Void
}

public protocol DashboardWizardViewModel: ObservableObject {
    /// External flow that are not handler within the module
    var externalFlows: DashboardWizardExternalFlow? { get set }
    /// Current mode to setup the wizard
    var mode: DashboardWizardMode { get }
    /// Alert data to show over the screen
    var toastData: DefaultToastDataContent? { get set }
    /// List of all available icons to represent the  dashboard
    var icons: [Icon] { get }
    /// Text to filter the icon list
    var iconFilterText: String { get set }
    /// Dashboard's name
    var dashboardName: String { get set }
    /// Dashboard's icon
    var selectedIconName: String? { get set }
    /// Number of columns to use in the dashboard
    var columnsNumber: Int { get set }
    /// When the user clicks on close
    func close()
    /// When the user clicks to create or update the dashboard
    func createOrUpdateDashboard()
}
