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

public class WidgetEditViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: WidgetEditViewModel {

    public var delegate: WidgetEditExternalFlow?

    // MARK: Services

    private var dashboardService: DashboardS
    private var entitiesService: EntityS

    // MARK: Publishers

    // MARK: Gets

    // MARK: Init

    public init(dashboardService: DashboardS, entitiesService: EntityS) {
        self.dashboardService = dashboardService
        self.entitiesService = entitiesService
    }
}
