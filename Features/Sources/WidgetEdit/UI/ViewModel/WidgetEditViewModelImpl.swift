//
//  WidgetEditViewModelImpl.swift
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

private extension WidgetEditMode {

    var totalSteps: Int {
        switch self {
        case .creation:
            return 2
        case .edit:
            return 1
        }
    }
}

public class WidgetEditViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: WidgetEditViewModel {

    public var delegate: WidgetEditExternalFlow?
    public private(set) var mode: WidgetEditMode

    // MARK: Services

    private var dashboardService: DashboardS
    private var entityService: EntityS

    // MARK: Publishers

    @Published public var toastData: DefaultToastDataContent?
    @Published public var currentStep: Int = .zero

    // MARK: Gets

    public var isFirstStep: Bool { currentStep == .zero }
    public var isLastStep: Bool { currentStep == (mode.totalSteps - 1) }

    // MARK: Init

    public init(dashboardService: DashboardS, entityService: EntityS, dashboard: Dashboard, mode: WidgetEditMode) {
        self.dashboardService = dashboardService
        self.entityService = entityService
        self.mode = mode

        setupData(mode)
    }
}

// MARK: - Setups

extension WidgetEditViewModelImpl {

    private func setupData(_ mode: WidgetEditMode) {
    }
}

// MARK: - Private Methods

extension WidgetEditViewModelImpl {

    private func setError(
        message: String,
        logMessage: String? = nil
    ) {
        toastData = .init(type: .error, title: message)
        Logger.log(level: .error, logMessage ?? message)
    }
}

// MARK: - Public Methods

extension WidgetEditViewModelImpl {

    public func nextStep() {
        currentStep += 1
    }

    public func previousStep() {
        currentStep -= 1
    }

    public func createOrUpdateWidget() {

    }

    public func close() {
        delegate?.didClose()
    }
}
