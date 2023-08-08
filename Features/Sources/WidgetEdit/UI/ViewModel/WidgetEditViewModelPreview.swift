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

    var selectedViewID: String = "default"
    var viewIDs: [String] = WidgetViewList.fan.map { $0.uniqueID }
    var toastData: DefaultToastDataContent?

    init(entity: any Entity) {
        self.widgetData = (WidgetConfig(id: "default", entityID: entity.id), entity)
    }

    func close() {}
    func updateWidget() {}
}
#endif
