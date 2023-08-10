//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import DesignSystem
import Foundation

protocol WidgetUISelectionExternalFlow {

    func didClose()
}

protocol WidgetUISelectionViewModel: ObservableObject {

    var delegate: WidgetUISelectionExternalFlow? { get set }

    var entity: any Entity { get }
    var widgetCustomInfo: WidgetCustomInfo { get }

    var widgetTitle: String { get set }
    var selectedViewID: String { get set }
    var viewIDs: [String] { get }

    var doesWidgetAlreadyExist: Bool { get }
    var toastData: DefaultToastDataContent? { get set }

    func createOrUpdateWidget()
}
