//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Combine
import Domain

public protocol DashboardExternalFlow {
    /// When the config button is selected
    func didSelectConfig() -> Void
    /// When the add button is selected
    func didSelectAddDashboard() -> Void
    /// When the add widget button is selected
    func didSelectAddWidget(_ dashboard: Dashboard) -> Void
    /// When the edit dashboard button is selected
    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void
}

public protocol DashboardViewModel: ObservableObject {
    /// External flow that are not handler within the module
    var externalFlows: DashboardExternalFlow? { get set }
    /// Stores the current selected dashboard name
    var selectedDashboardName: String? { get set }
    /// All widgets for the selected dashboard
    var widgets: [WidgetData] { get set }
    /// All dashboards available
    var dashboards: [Dashboard] { get set }
    /// Alert data to show over the screen
    var toastData: DefaultToastDataContent? { get set }
    // When the user clicks on config button
    func didClickConfig()
    // When the user clicks on edit button
    func didClickEdit()
    // When the user clicks on add dashboard button
    func didClickAddDashboard()
    // When the user clicks on add widget button
    func didClickAddWidget()
    // When the user request to change light state
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
    // When the user request to change fan state
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State)
}
