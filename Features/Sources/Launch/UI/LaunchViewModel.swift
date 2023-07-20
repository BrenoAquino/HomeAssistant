//
//  LaunchViewModel.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

enum LaunchViewModelStates {
    case loading
    case finished
    case error
}

public class LaunchViewModel: ObservableObject {

    private let entityService: EntityService
    private let dashboardService: DashboardService

    // MARK: Redirects

    public var launchFinished: (() -> Void)?

    // MARK: Publishers

    @Published private(set) var state: LaunchViewModelStates = .loading

    // MARK: Init

    public init(entityService: EntityService, dashboardService: DashboardService) {
        self.entityService = entityService
        self.dashboardService = dashboardService
    }
}

// MARK: - Interfaces

extension LaunchViewModel {

    func startConfiguration() async {
        do {
            try await entityService.trackEntities()
            try await dashboardService.trackDashboards()

            await MainActor.run { [self] in
                state = .finished
                launchFinished?()
            }
        } catch {
            Logger.log(level: .error, error.localizedDescription)
            await MainActor.run { [self] in
                state = .error
            }
        }
    }
}
