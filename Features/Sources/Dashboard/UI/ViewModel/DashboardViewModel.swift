//
//  DashboardViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Combine
import Domain

public protocol DashboardViewModel: ObservableObject {

    var editModel: Bool { get set }
    var selectedDashboardIndex: Int? { get set }
    var dashboards: [Dashboard] { get set }
    var currentDashboard: Dashboard? { get }
    var entities: [any Entity] { get }

    var didSelectAddDashboard: (() -> Void)? { get set }
    var didSelectEditDashboard: ((_ dashboard: Dashboard) -> Void)? { get set }

    func didUpdateLightState(_ lightEntityUI: LightEntityUI, newState: LightStateUI)
    func didSelectAdd()
    func didSelectEdit(_ dashboard: Dashboard)
}
