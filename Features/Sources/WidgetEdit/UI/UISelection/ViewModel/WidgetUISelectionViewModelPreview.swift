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

    var entity: any Entity = EntityMock.fan
    var widgetTitle: String = "Fan"
    var viewIDs: [String] = WidgetViewList.fan.map { $0.uniqueID }
    var selectedViewID: String = "default"

    func createOrUpdateWidget() {}
}
#endif
