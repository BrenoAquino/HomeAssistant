//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Combine
import Domain

public typealias WidgetData = (widget: EntityWidget, entity: any Entity)

public protocol DashboardExternalFlow {

    func didSelectConfig() -> Void
    func didSelectAddDashboard() -> Void
    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void
}

public protocol DashboardViewModel: ObservableObject {

    var delegate: DashboardExternalFlow? { get set }

    var selectedDashboardName: String? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }
    var widgets: [WidgetData] { get set }

    var editModel: Bool { get set }
    var toastData: DefaultToastDataContent? { get set }

    var removeDashboardAlert: Bool { get set }
    var removeEntityAlert: Bool { get set }

    func deleteRequestedDashboard()
    func cancelDashboardDeletion()
    func deleteRequestedEntity()
    func cancelEntityDeletion()

    func didUpdateWidgetsOrder(_ widgets: [WidgetData])
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard])

    func didClickAddDashboard()
    func didClickRemove(dashboard: Dashboard)
    func didClickEdit(dashboard: Dashboard)
    func didClickRemove(widget: WidgetData)
    func didClickConfig()

    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State)
}
