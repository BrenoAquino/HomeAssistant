//
//  DashboardViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Combine
import Domain
import Preview

class DashboardViewModelPreview: DashboardViewModel {

    var delegate: DashboardExternalFlow?
    var toastData: DefaultToastDataContent?

    @Published var removeAlert: Bool = false
    @Published var editModel: Bool = false
    @Published var selectedDashboardName: String? = "Bedroom"
    @Published var dashboards: [Dashboard] = DashboardMock.all

    var currentDashboard: Dashboard? {
        return dashboards[0]
    }

    var entities: [any Entity] {
        get {
            guard let currentDashboard else { return [] }
            return currentDashboard.entitiesIDs.compactMap { EntityMock.allDict[$0] }
        }
        set {
            
        }
    }

    func deleteRequestedDashboard() {}
    func cancelDashboardDeletion() {}
    func didUpdateEntitiesOrder(_ entities: [any Entity]) {}
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard]) {}
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {}
    func didClickAdd() {}
    func didClickRemove(_ dashboard: Dashboard) {}
    func didClickEdit(_ dashboard: Dashboard) {}
    func didClickConfig() {}
}
#endif
