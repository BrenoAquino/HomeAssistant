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
}

public protocol DashboardViewModel: ObservableObject {

    var delegate: DashboardExternalFlow? { get set }
    var removeDashboardAlert: Bool { get set }
    var removeEntityAlert: Bool { get set }
    var editModel: Bool { get set }
    var selectedDashboardName: String? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }
    var entities: [any Entity] { get set }
    var toastData: DefaultToastDataContent? { get set }

    func deleteRequestedDashboard()
    func cancelDashboardDeletion()
    func deleteRequestedEntity()
    func cancelEntityDeletion()

    func didUpdateEntitiesOrder(_ entities: [any Entity])
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard])

    func didClickAddDashboard()
    func didClickRemove(dashboard: Dashboard)
    func didClickEdit(dashboard: Dashboard)
    func didClickRemove(entity: any Entity)
    func didClickConfig()

    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State)
}
