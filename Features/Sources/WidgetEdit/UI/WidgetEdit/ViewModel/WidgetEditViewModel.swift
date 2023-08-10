//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import Foundation
import SwiftUI

public enum WidgetEditMode {

    case creation
    case edit(widgetData: WidgetData)
}

public protocol WidgetEditExternalFlow {

    func didClose()
}

public protocol WidgetEditViewModel: ObservableObject {

    var delegate: WidgetEditExternalFlow? { get set }
    var mode: WidgetEditMode { get }
    var dashboard: Dashboard { get }

    func entitySelection() -> AnyView
    func uiSelection(_ entity: any Entity) -> AnyView
    func uiSelection(_ widgetData: WidgetData) -> AnyView
}
