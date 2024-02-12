//
//  LaunchViewModelImpl.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Domain
import Foundation

public class LaunchViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: LaunchViewModel {
    public var externalFlows: LaunchExternalFlow?

    // MARK: Services

    private let entityService: EntityS
    private let dashboardService: DashboardS

    // MARK: Publishers

    @Published public private(set) var state: LaunchViewModelState = .loading
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Init

    public init(entityService: EntityS, dashboardService: DashboardS) {
        self.entityService = entityService
        self.dashboardService = dashboardService
    }
}

// MARK: Public Methods

extension LaunchViewModelImpl {
    public func configure() async {
        await MainActor.run { [self] in
            state = .loading
        }
        do {
            try await dashboardService.load()
            try await entityService.load()
            try await entityService.startTracking()
            await MainActor.run { [self] in
                externalFlows?.launchFinished()
            }
        } catch {
            await MainActor.run { [self] in
                toastData = .init(type: .error, title: Localizable.connectionError.value)
                state = .error
            }
        }
    }
}
