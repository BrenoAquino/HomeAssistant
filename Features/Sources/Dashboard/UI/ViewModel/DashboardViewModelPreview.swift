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
    var removeEntityAlert: Bool = false
    var removeDashboardAlert: Bool = false

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
    func deleteRequestedEntity() {}
    func cancelEntityDeletion() {}
    func didUpdateEntitiesOrder(_ entities: [any Entity]) {}
    func didUpdateDashboardsOrder(_ dashboards: [Dashboard]) {}
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {}
    func didClickAddDashboard() {}
    func didClickRemove(dashboard: Dashboard) {}
    func didClickEdit(dashboard: Dashboard) {}
    func didClickRemove(entity: any Entity) {}
    func didClickConfig() {}
}
#endif
