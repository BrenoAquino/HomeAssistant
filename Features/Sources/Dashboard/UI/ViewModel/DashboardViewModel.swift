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

    func didSelectConfig() -> Void
    func didSelectAddDashboard() -> Void
    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void
    func didSelectEditWidget(_ widgetData: WidgetData, _ dashboard: Dashboard)
}

public protocol DashboardViewModel: ObservableObject {

    var delegate: DashboardExternalFlow? { get set }

    var editModel: Bool { get set }

    var selectedDashboardName: String? { get set }
    var dashboards: [Dashboard] { get set }
    var widgets: [WidgetData] { get set }

    var removeDashboardAlert: Bool { get set }
    var removeWidgetAlert: Bool { get set }

    var toastData: DefaultToastDataContent? { get set }

    func deleteRequestedDashboard()
    func cancelDashboardDeletion()

    func deleteRequestedWidget()
    func cancelWidgetDeletion()

    func didUpdateWidgetsOrder(_ widgets: [WidgetData])
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard])

    func didClickConfig()
    func didClickAddDashboard()
    func didClickEdit(dashboard: Dashboard)
    func didClickEdit(widget: WidgetData)
    func didClickRemove(dashboard: Dashboard)
    func didClickRemove(widget: WidgetData)

    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State)
}
