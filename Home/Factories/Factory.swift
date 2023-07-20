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

    private let configService: ConfigService
    private let entityService: EntityService
    private let dashboardService: DashboardService

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

    func getDashboardService() -> DashboardService {
        dashboardService
    }
}

// MARK: ViewModel

extension Factory {

    func getLaunchViewModel() -> LaunchViewModel {
        LaunchViewModel(entityService: entityService)
    }

    func getDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(dashboardService: dashboardService)
    }

    func getDashboardCreationViewModel(mode: DashboardCreationMode) -> DashboardCreationViewModel {
        DashboardCreationViewModel(
            dashboardService: dashboardService,
            entitiesService: entityService,
            mode: mode
        )
    }
}

// MARK: Coordinator

extension Factory {

    func getLaunchCoordinator() -> LaunchCoordinator {
        LaunchCoordinator(viewModel: getLaunchViewModel())
    }

    func getDashboardCoordinator() -> DashboardCoordinator {
        DashboardCoordinator(viewModel: getDashboardViewModel())
    }

    func getDashboardCreationCoordinator(mode: DashboardCreationMode) -> DashboardCreationCoordinator {
        DashboardCreationCoordinator(viewModel: getDashboardCreationViewModel(mode: mode))
    }
}
