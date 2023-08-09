//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import Foundation

protocol WidgetUISelectionViewModel: ObservableObject {

    var entity: (any Entity) { get }
    var widgetTitle: String { get set }
    var viewIDs: [String] { get }
    var selectedViewID: String { get set }

    func createOrUpdateWidget()
}
