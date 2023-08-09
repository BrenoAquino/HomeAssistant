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
    case edit(entity: any Entity)
}

public protocol WidgetEditExternalFlow {

    func didClose()
}

public protocol WidgetEditViewModel: ObservableObject {

    var delegate: WidgetEditExternalFlow? { get set }
    var mode: WidgetEditMode { get }

    func entitySelection() -> any View
    func uiSelection(_ entity: any Entity) -> any View
}
