//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

#if DEBUG
import Foundation
import Preview
import DesignSystem
import Domain

class WidgetUISelectionViewModelPreview: WidgetUISelectionViewModel {

    var delegate: WidgetUISelectionExternalFlow?
    var toastData: DefaultToastDataContent?
    var entity: any Entity = EntityMock.fan
    var widgetCustomInfo: WidgetCustomInfo = .init(title: EntityMock.fan.name)
    var widgetTitle: String = "Fan"
    var viewIDs: [String] = WidgetViewList.fan.map { $0.uniqueID }
    var selectedViewID: String = "default"
    var doesWidgetAlreadyExist: Bool = false

    func createOrUpdateWidget() {}
}
#endif
