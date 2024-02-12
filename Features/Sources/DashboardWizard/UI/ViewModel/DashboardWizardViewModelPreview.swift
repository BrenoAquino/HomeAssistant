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

class DashboardWizardViewModelPreview: DashboardWizardViewModel {
    var externalFlows: DashboardWizardExternalFlow?
    var mode: DashboardWizardMode = .creation
    var toastData: DefaultToastDataContent?
    var icons: [Icon] = Icon.list
    var iconFilterText: String = ""
    var dashboardName: String = ""
    var selectedIconName: String? = Icon.list.first?.name
    var columnsNumber: Int = 3
    func close() {}
    func createOrUpdateDashboard() {}
}
#endif
