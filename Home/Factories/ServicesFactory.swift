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

    init(repositoryFactory: RepositoryFactory) {
        configService = ConfigServiceImpl(fetcherRepository: repositoryFactory.fetcherRepository)
        entityService = EntityServiceImpl(
            fetcherRepository: repositoryFactory.fetcher(),
            commandRepository: repositoryFactory.command(),
            subscriptionRepository: repositoryFactory.subscription()
        )
    }

    func config() -> ConfigService {
        configService
    }

    func entity() -> EntityService {
        entityService
    }
}
