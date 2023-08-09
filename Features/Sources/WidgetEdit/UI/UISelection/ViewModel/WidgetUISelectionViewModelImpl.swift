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

    let entity: any Entity
    let viewIDs: [String]

    // MARK: Publishers

    @Published var widgetTitle: String
    @Published var selectedViewID: String

    // MARK: Init

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
