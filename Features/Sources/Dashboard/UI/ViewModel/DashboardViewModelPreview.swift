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
    var externalFlows: DashboardExternalFlow?
    var selectedDashboardName: String? = "Bedroom"
    var widgets: [WidgetData] = [
        .init(
            config: .mock(entity: LightEntity.mockMainLight),
            entity: LightEntity.mockMainLight
        ),
        .init(
            config: .mock(entity: LightEntity.mockLedDeskLight),
            entity: LightEntity.mockLedDeskLight
        ),
        .init(
            config: .mock(entity: LightEntity.mockLedCeilingLight),
            entity: LightEntity.mockLedCeilingLight
        ),
    ]
    var dashboards: [Dashboard] = Dashboard.all
    var toastData: DefaultToastDataContent?
    func didClickConfig() {}
    func didClickEdit() {}
    func didClickAddDashboard() {}
    func didClickAddWidget() {}
    func didClickUpdateLightState(_ lightEntity: LightEntity, newState: LightEntity.State) {}
    func didClickUpdateFanState(_ fanEntity: FanEntity, newState: FanEntity.State) {}
}
#endif
