//
//  LaunchViewModelImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Domain
import Foundation

public class LaunchViewModelImpl<
    DashboardS: DashboardService,
    DashboardS_v2: DashboardService_v2,
    EntityS: EntityService,
    EntityS_v2: EntityService_v2
>: LaunchViewModel {

    public var delegate: LaunchExternalFlow?

    // MARK: Services

    private let entityService: EntityS
    private let dashboardService: DashboardS
    private let entityService_v2: EntityS_v2
    private let dashboardService_v2: DashboardS_v2

    // MARK: Publishers

    @Published public var state: LaunchViewModelState = .loading
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Init

    public init(entityService: EntityS, entityService_v2: EntityS_v2, dashboardService: DashboardS, dashboardService_v2: DashboardS_v2) {
        self.entityService = entityService
        self.entityService_v2 = entityService_v2
        self.dashboardService = dashboardService
        self.dashboardService_v2 = dashboardService_v2
    }
}

// MARK: Public Methods

extension LaunchViewModelImpl {

    public func startConfiguration() async {
        await MainActor.run { [self] in
            state = .loading
        }

        do {
            try await entityService.trackEntities()
            try await entityService_v2.startTracking()
            try await dashboardService.trackDashboards()
            try await dashboardService_v2.load()

            await MainActor.run { [self] in
                delegate?.launchFinished()
            }
        } catch {
            Logger.log(level: .error, error.localizedDescription)
            await MainActor.run { [self] in
                toastData = .init(type: .error, title: Localizable.connectionError.value)
                state = .error
            }
        }
    }
}
