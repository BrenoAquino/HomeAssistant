//
//  WidgetEditViewModel.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import Combine
import Common
import Domain
import Foundation
import SwiftUI

public protocol WidgetEditExternalFlow {

    func didFinish(_ widget: WidgetConfig) -> Void
    func didClose() -> Void
}

public protocol WidgetEditViewModel: ObservableObject {

    var delegate: WidgetEditExternalFlow? { get set }
}
