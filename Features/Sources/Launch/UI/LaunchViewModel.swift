//
//  LaunchViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

// MARK: - Interface

public protocol LaunchViewModel: ObservableObject {

    var launchFinished: (() -> Void)? { get set }

    func startConfiguration() async
}

// MARK: - Implementation

public class LaunchViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: LaunchViewModel {

    private let entityService: EntityS
    private let dashboardService: DashboardS

    // MARK: Redirects

    public var launchFinished: (() -> Void)?

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
                launchFinished?()
            }
        } catch {
            Logger.log(level: .error, error.localizedDescription)
        }
    }
}
