//
//  DashboardEditViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Preview
import Domain

class DashboardEditViewModelPreview: DashboardEditViewModel {

    var toastData: DefaultToastDataContent?
    var delegate: DashboardEditExternalFlow?
    var mode: DashboardEditMode = .creation
    var dashboardName: String = ""
    var icons: [Icon] = Icon.list
    var selectedIconName: String? = Icon.list.first?.name
    var iconFilterText: String = ""
    var columnsNumber: Int = 3

    func close() {}
    func createOrUpdateDashboard() {}
}
#endif
