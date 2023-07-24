//
//  File.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import Preview
import Domain

class DashboardCreationViewModelPreview: DashboardCreationViewModel {

    var delegate: DashboardCreationExternalFlow?
    var mode: DashboardCreationMode = .creation
    var dashboardName: String = ""
    var icons: [Icon] = Icon.list
    var selectedIconName: String? = Icon.list.first?.name
    var iconFilterText: String = ""
    var entities: [any Entity] = EntityMock.all
    var selectedEntitiesIDs: Set<String> = []
    var entityFilterText: String = ""
    var domains: [EntityDomain] = EntityDomain.allCases
    var selectedDomainsNames: Set<String> = Set(EntityDomain.allCases.map { $0.rawValue })

    func close() {}
    func createOrUpdateDashboard() {}
}
#endif
