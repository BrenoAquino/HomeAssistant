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

public enum WidgetEditMode {

    case creation
    case edit(widgetData: WidgetData)
}

public enum WidgetEditStep: String {

    case entitySelection
    case uiSelection
}

public protocol WidgetEditExternalFlow {

    func didFinish() -> Void
    func didClose() -> Void
}

public protocol WidgetEditViewModel: ObservableObject {

    var mode: WidgetEditMode { get }
    var delegate: WidgetEditExternalFlow? { get set }
    var toastData: DefaultToastDataContent? { get set }

    // Tabs
    var currentStep: WidgetEditStep { get set }
    var isFirstStep: Bool { get }
    var isLastStep: Bool { get }

    // Entity Selection
    var entities: [any Entity] { get }
    var entityFilterText: String { get set }
    var domains: [EntityDomain] { get }
    var selectedDomainsNames: Set<String> { get set }

    func didSelectEntity(_ entity: any Entity)

    // Tabs
    func nextStep()
    func previousStep()
    func createOrUpdateWidget()
    func close()
}
