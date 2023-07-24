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

    weak var delegate: DashboardExternalFlow?

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

    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {
        print("didUpdateLightState \(lightEntity.name) \(newState.rawValue)")
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
