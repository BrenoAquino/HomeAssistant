//
//  LaunchViewModelImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

public class LaunchViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: LaunchViewModel {

    public var delegate: LaunchExternalFlow?

    // MARK: Services

    private let entityService: EntityS
    private let dashboardService: DashboardS

    // MARK: Init

    public init(entityService: EntityS, dashboardService: DashboardS) {
        self.entityService = entityService
        self.dashboardService = dashboardService
    }
}

// MARK: Public Methods

extension LaunchViewModelImpl {

    public func startConfiguration() async {
        do {
            try await entityService.trackEntities()
            try await dashboardService.trackDashboards()

            await MainActor.run { [self] in
                delegate?.launchFinished()
            }
        } catch {
            Logger.log(level: .error, error.localizedDescription)
        }
    }
}
