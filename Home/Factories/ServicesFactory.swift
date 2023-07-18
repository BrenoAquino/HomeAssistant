//
//  ServicesFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

class ServicesFactory {

    private let configService: ConfigService
    private let entityService: EntityService
    private let dashboardService: DashboardService

    init(repositoryFactory: RepositoryFactory) {
        configService = ConfigServiceImpl(fetcherRepository: repositoryFactory.fetcher())
        entityService = EntityServiceImpl(
            fetcherRepository: repositoryFactory.fetcher(),
            commandRepository: repositoryFactory.command(),
            subscriptionRepository: repositoryFactory.subscription()
        )
        dashboardService = DashboardServiceImpl(
            entityService: entityService,
            dashboardRepository: repositoryFactory.dashboard()
        )
    }

    func config() -> ConfigService {
        configService
    }

    func entity() -> EntityService {
        entityService
    }

    func dashboard() -> DashboardService {
        dashboardService
    }
}
