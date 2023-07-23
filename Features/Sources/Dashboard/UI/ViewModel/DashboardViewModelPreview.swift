//
//  File.swift
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

    var didSelectAddDashboard: (() -> Void)?
    var didSelectEditDashboard: ((Dashboard) -> Void)?

    func didSelectAdd() { print("didSelectAdd") }
    func didSelectEdit(_ dashboard: Dashboard) { print("didSelectEdit \(dashboard.name)") }
}
#endif
