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

public enum WidgetEditMode: Equatable {

    case creation
    case edit(widgetData: WidgetData)

    public static func == (lhs: WidgetEditMode, rhs: WidgetEditMode) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}

public protocol WidgetEditExternalFlow {

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol WidgetEditViewModel: ObservableObject {

    var mode: WidgetEditMode { get }
    var delegate: WidgetEditExternalFlow? { get set }
    var toastData: DefaultToastDataContent? { get set }

    var currentStep: Int { get set }
    var isFirstStep: Bool { get }
    var isLastStep: Bool { get }

    func nextStep()
    func previousStep()
    func createOrUpdateWidget()
    func close()
}
