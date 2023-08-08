//
//  WidgetEditViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Preview
import Domain

class WidgetEditViewModelPreview: WidgetEditViewModel {

    var delegate: WidgetEditExternalFlow?
    var widgetData: WidgetData

    var widgetTitle: String
    var selectedViewID: String = "default"
    var viewIDs: [String] = WidgetViewList.fan.map { $0.uniqueID }
    var toastData: DefaultToastDataContent?

    var entity: any Entity { widgetData.entity }
    var widgetConfig: WidgetConfig { widgetData.config }

    init(entity: any Entity) {
        self.widgetData = (WidgetConfig(id: "default", entityID: entity.id), entity)
        widgetTitle = entity.name
    }

    func close() {}
    func updateWidget() {}
}
#endif
