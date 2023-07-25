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

    var delegate: DashboardExternalFlow?

    @Published var removeAlert: Bool = false
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

    public func deleteRequestedDashboard() {
        print("deleteRequestedDashboard")
    }

    public func cancelDashboardDeletion() {
        print("cancelDashboardDeletion")
    }

    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {
        print("didUpdateLightState \(lightEntity.name) \(newState.rawValue)")
    }

    func didClickAdd() {
        print("didSelectAdd")
    }

    func didClickRemove(_ dashboard: Dashboard) {
        print("didClickRemove \(dashboard.name)")
    }

    func didClickEdit(_ dashboard: Dashboard) {
        print("didSelectEdit \(dashboard.name)")
    }

    func didClickConfig() {
        print("didClickConfig")
    }
}
#endif
