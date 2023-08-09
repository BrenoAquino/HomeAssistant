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

    var mode: WidgetEditMode = .creation
    var delegate: WidgetEditExternalFlow?
    var widgetData: WidgetData?

    var widgetTitle: String?
    var selectedViewID: String? = "default"
    var viewIDs: [String]? = WidgetViewList.fan.map { $0.uniqueID }
    var toastData: DefaultToastDataContent?

    var entity: (any Entity)? { widgetData?.entity }
    var widgetConfig: WidgetConfig? { widgetData?.config }

    var currentStep: Int = 0
    var isLastStep: Bool = false
    var isFirstStep: Bool = false

    init() {
        let entity = EntityMock.fan
        self.widgetData = (WidgetConfig(id: "default", entityID: entity.id, title: entity.name), entity)
        widgetTitle = entity.name
    }

    func nextStep() {}
    func previousStep() {}
    func close() {}
    func createOrUpdateWidget() {}
}
#endif
