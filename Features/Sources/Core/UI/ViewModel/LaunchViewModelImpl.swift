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

    public var delegate: LaunchExternalFlow?

    // MARK: Services

    private let entityService: EntityS
    private let dashboardService: DashboardS

    // MARK: Publishers

    @Published public var state: LaunchViewModelState = .loading
    @Published public var toastData: DefaultToastDataContent?

    // MARK: Init

    public init(entityService: EntityS, dashboardService: DashboardS) {
        self.entityService = entityService
        self.dashboardService = dashboardService
    }
}

// MARK: Public Methods

extension LaunchViewModelImpl {

    public func startConfiguration() async {
        await MainActor.run { [self] in
            state = .loading
        }

        do {
            try await entityService.startTracking()
            try await dashboardService.load()

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
