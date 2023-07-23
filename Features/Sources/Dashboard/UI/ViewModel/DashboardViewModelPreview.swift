//
//  DashboardViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import Combine
import Domain
import Preview

class DashboardViewModelPreview: DashboardViewModel {

    @Published var editModel: Bool = false
    @Published var selectedDashboardIndex: Int? = 0
    @Published var dashboards: [Dashboard] = DashboardMock.all

    var currentDashboard: Dashboard? {
        guard let selectedDashboardIndex else { return nil }
        return dashboards[selectedDashboardIndex]
    }

    var entities: [any Entity] {
        guard let currentDashboard else { return [] }
        return currentDashboard.entitiesIDs.compactMap { EntityMock.allDict[$0] }
    }

    var didSelectConfig: (() -> Void)?
    var didSelectAddDashboard: (() -> Void)?
    var didSelectEditDashboard: ((Dashboard) -> Void)?

    func didClickUpdateLightState(_ lightEntityUI: LightEntityUI, newState: LightStateUI) {
        print("didUpdateLightState \(lightEntityUI.name) \(newState.rawValue)")
    }

    func didClickAdd() {
        print("didSelectAdd")
    }

    func didClickEdit(_ dashboard: Dashboard) {
        print("didSelectEdit \(dashboard.name)")
    }

    func didClickConfig() {
        print("didClickConfig")
    }
}
#endif
