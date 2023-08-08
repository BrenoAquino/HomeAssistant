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

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol WidgetEditViewModel: ObservableObject {

    var delegate: WidgetEditExternalFlow? { get set }
    var widgetData: WidgetData { get }
    var toastData: DefaultToastDataContent? { get set }

    var selectedViewID: String { get set }
    var viewIDs: [String] { get }

    func updateWidget()
    func close()
}
