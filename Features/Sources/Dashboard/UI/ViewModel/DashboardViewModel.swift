//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Domain

public protocol DashboardExternalFlow {

    func didSelectConfig() -> Void
    func didSelectAddDashboard() -> Void
    func didSelectEditDashboard(_ dashboard: Dashboard) -> Void
}

public protocol DashboardViewModel: ObservableObject {

    var delegate: DashboardExternalFlow? { get set }

    var editModel: Bool { get set }
    var selectedDashboardIndex: Int? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }
    var entities: [any Entity] { get }

    func didClickAdd()
    func didClickEdit(_ dashboard: Dashboard)
    func didClickConfig()
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State)
}
