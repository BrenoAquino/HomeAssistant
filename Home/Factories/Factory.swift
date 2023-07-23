//
//  Factory.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Domain
import Data
import Dashboard
import Launch
import DashboardCreation
import Foundation
import SwiftUI

class Factory {

    private let webSocketProvider: WebSocketProvider
    private let databaseProvider: DatabaseProvider

    private let dashboardLocalDataSource: DashboardLocalDataSource

    private let commandRemoteDataSource: CommandRemoteDataSource
    private let fetcherRemoteDataSource: FetcherRemoteDataSource
    private let subscriptionRemoteDataSource: SubscriptionRemoteDataSource

    private let commandRepository: CommandRepository
    private let fetcherRepository: FetcherRepository
    private let subscriptionRepository: SubscriptionRepository
    private let dashboardRepository: DashboardRepository

    private let configService: ConfigServiceImpl
    private let entityService: EntityServiceImpl
    private let dashboardService: DashboardServiceImpl

    init() {
        webSocketProvider = try! WebSocket(url: AppEnvironment.homeAssistantURL, token: AppEnvironment.authToken)
        databaseProvider = UserDefaultsDatabaseProvider()

        dashboardLocalDataSource = DashboardLocalDataSourceImpl(databaseProvider: databaseProvider)

        commandRemoteDataSource = CommandRemoteDataSourceImpl(webSocketProvider: webSocketProvider)
        fetcherRemoteDataSource = FetcherRemoteDataSourceImpl(webSocketProvider: webSocketProvider)
        subscriptionRemoteDataSource = SubscriptionRemoteDataSourceImpl(webSocketProvider: webSocketProvider)

        commandRepository = CommandRepositoryImpl(commandRemoteDataSource: commandRemoteDataSource)
        fetcherRepository = FetcherRepositoryImpl(fetcherRemoteDataSource: fetcherRemoteDataSource)
        subscriptionRepository = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: subscriptionRemoteDataSource)
        dashboardRepository = DashboardRepositoryImpl(dashboardLocalDataSource: dashboardLocalDataSource)

        configService = ConfigServiceImpl(fetcherRepository: fetcherRepository)
        entityService = EntityServiceImpl(
            fetcherRepository: fetcherRepository,
            commandRepository: commandRepository,
            subscriptionRepository: subscriptionRepository
        )
        dashboardService = DashboardServiceImpl(
            entityService: entityService,
            dashboardRepository: dashboardRepository
        )
    }
}

// MARK: Infrastructure

extension Factory {

    func getWebSocket() -> WebSocketProvider {
        webSocketProvider
    }

    func getDatabase() -> DatabaseProvider {
        databaseProvider
    }
}

// MARK: LocalDataSource

extension Factory {

    func getDashboardLocalDataSource() -> DashboardLocalDataSource {
        dashboardLocalDataSource
    }
}

// MARK: RemoteDataSource

extension Factory {

    func getCommandRemoteDataSource() -> CommandRemoteDataSource {
        commandRemoteDataSource
    }

    func getFetcherRemoteDataSource() -> FetcherRemoteDataSource {
        fetcherRemoteDataSource
    }

    func getSubscriptionRemoteDataSource() -> SubscriptionRemoteDataSource {
        subscriptionRemoteDataSource
    }
}

// MARK: Repository

extension Factory {

    func getCommandRepository() -> CommandRepository {
        commandRepository
    }

    func getFetcherRepository() -> FetcherRepository {
        fetcherRepository
    }

    func getSubscriptionRepository() -> SubscriptionRepository {
        subscriptionRepository
    }

    func getDashboardRepository() -> DashboardRepository {
        dashboardRepository
    }
}

// MARK: Service

extension Factory {

    func getConfigService() -> ConfigService {
        configService
    }

    func getEntityService() -> EntityService {
        entityService
    }

    func getDashboardService() -> any DashboardService {
        dashboardService
    }
}

// MARK: Coordinator

extension Factory {

    @ViewBuilder func getLaunchCoordinator() -> some View {
        let viewModel = LaunchViewModelImpl(entityService: entityService, dashboardService: dashboardService)
        LaunchCoordinator(viewModel: viewModel)
    }

    @ViewBuilder func getDashboardCoordinator() -> some View {
        let viewModel = DashboardViewModelImpl(dashboardService: dashboardService, entityService: entityService)
        DashboardCoordinator(viewModel: viewModel)
    }

//    func getDashboardCreationCoordinator(mode: DashboardCreationMode) -> DashboardCreationCoordinator {
//        DashboardCreationCoordinator(viewModel: getDashboardCreationViewModel(mode: mode))
//    }
}
