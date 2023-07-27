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

    var removeAlert: Bool { get set }
    var editModel: Bool { get set }
    var selectedDashboardName: String? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }
    var entities: [any Entity] { get set }

    var toastData: DefaultToastDataContent? { get set }

    func deleteRequestedDashboard()
    func cancelDashboardDeletion()

    func didUpdateEntitiesOrder(_ entities: [any Entity])
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard])

    func didClickAdd()
    func didClickRemove(_ dashboard: Dashboard)
    func didClickEdit(_ dashboard: Dashboard)
    func didClickConfig()
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
}
