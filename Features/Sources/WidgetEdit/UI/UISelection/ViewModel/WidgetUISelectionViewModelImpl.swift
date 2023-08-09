//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import Domain
import Foundation

class WidgetUISelectionViewModelImpl: WidgetUISelectionViewModel {

    var entity: any Entity
    var widgetTitle: String
    var viewIDs: [String]
    var selectedViewID: String

    init(entity: any Entity, selectedViewID: String = "default") {
        self.entity = entity
        self.selectedViewID = selectedViewID
        widgetTitle = entity.name

        switch entity.domain {
        case .light:
            viewIDs = WidgetViewList.light.map { $0.uniqueID }
        case .fan:
            viewIDs = WidgetViewList.fan.map { $0.uniqueID }
        case .climate, .switch:
            viewIDs = []
        }
    }
}

// MARK: - Methods

extension WidgetUISelectionViewModelImpl {

    func createOrUpdateWidget() {

    }
}
