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

    private let webSocketProviderInstance: WebSocketProvider
    private let databaseProviderInstance: DatabaseProvider

    private let dashboardLocalDataSourceInstance: DashboardLocalDataSource

    private let commandRemoteDataSourceInstance: CommandRemoteDataSource
    private let fetcherRemoteDataSourceInstance: FetcherRemoteDataSource
    private let subscriptionRemoteDataSourceInstance: SubscriptionRemoteDataSource

    private let commandRepositoryInstance: CommandRepository
    private let fetcherRepositoryInstance: FetcherRepository
    private let subscriptionRepositoryInstance: SubscriptionRepository
    private let dashboardRepositoryInstance: DashboardRepository

    private let configServiceInstance: ConfigServiceImpl
    private let entityServiceInstance: EntityServiceImpl
    private let dashboardServiceInstance: DashboardServiceImpl

    init() {
        webSocketProviderInstance = try! WebSocket(url: AppEnvironment.homeAssistantURL, token: AppEnvironment.authToken)
        databaseProviderInstance = UserDefaultsDatabaseProvider()

        dashboardLocalDataSourceInstance = DashboardLocalDataSourceImpl(databaseProvider: databaseProviderInstance)

        commandRemoteDataSourceInstance = CommandRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)
        fetcherRemoteDataSourceInstance = FetcherRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)
        subscriptionRemoteDataSourceInstance = SubscriptionRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)

        commandRepositoryInstance = CommandRepositoryImpl(commandRemoteDataSource: commandRemoteDataSourceInstance)
        fetcherRepositoryInstance = FetcherRepositoryImpl(fetcherRemoteDataSource: fetcherRemoteDataSourceInstance)
        subscriptionRepositoryInstance = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: subscriptionRemoteDataSourceInstance)
        dashboardRepositoryInstance = DashboardRepositoryImpl(dashboardLocalDataSource: dashboardLocalDataSourceInstance)

        configServiceInstance = ConfigServiceImpl(fetcherRepository: fetcherRepositoryInstance)
        dashboardServiceInstance = DashboardServiceImpl(dashboardRepository: dashboardRepositoryInstance)
        entityServiceInstance = EntityServiceImpl(
            fetcherRepository: fetcherRepositoryInstance,
            commandRepository: commandRepositoryInstance,
            subscriptionRepository: subscriptionRepositoryInstance
        )
    }
}

// MARK: Infrastructure

extension Factory: InfrastructureFactory {

    func webSocket() -> WebSocketProvider {
        webSocketProviderInstance
    }

    func database() -> DatabaseProvider {
        databaseProviderInstance
    }
}

// MARK: LocalDataSource

extension Factory: LocalDataSourceFactory {

    func dashboardLocalDataSource() -> DashboardLocalDataSource {
        dashboardLocalDataSourceInstance
    }
}

// MARK: RemoteDataSource

extension Factory: RemoteDataSourceFactory {

    func commandRemoteDataSource() -> CommandRemoteDataSource {
        commandRemoteDataSourceInstance
    }

    func fetcherRemoteDataSource() -> FetcherRemoteDataSource {
        fetcherRemoteDataSourceInstance
    }

    func subscriptionRemoteDataSource() -> SubscriptionRemoteDataSource {
        subscriptionRemoteDataSourceInstance
    }
}

// MARK: Repository

extension Factory: RepositoryFactory {

    func commandRepository() -> CommandRepository {
        commandRepositoryInstance
    }

    func fetcherRepository() -> FetcherRepository {
        fetcherRepositoryInstance
    }

    func subscriptionRepository() -> SubscriptionRepository {
        subscriptionRepositoryInstance
    }

    func dashboardRepository() -> DashboardRepository {
        dashboardRepositoryInstance
    }
}

// MARK: Service

extension Factory: ServicesFactory {

    func configService() -> ConfigService {
        configServiceInstance
    }

    func entityService() -> any EntityService {
        entityServiceInstance
    }

    func dashboardService() -> any DashboardService {
        dashboardServiceInstance
    }
}

// MARK: Coordinator

extension Factory {

    @ViewBuilder func getLaunchCoordinator() -> some View {
        let viewModel = LaunchViewModelImpl(entityService: entityServiceInstance, dashboardService: dashboardServiceInstance)
        LaunchCoordinator(viewModel: viewModel)
    }

    @ViewBuilder func getDashboardCoordinator() -> some View {
        let viewModel = DashboardViewModelImpl(dashboardService: dashboardServiceInstance, entityService: entityServiceInstance)
        DashboardCoordinator(viewModel: viewModel)
    }

    @ViewBuilder func getDashboardCreationCoordinator(mode: DashboardCreationMode) -> some View {
        let viewModel = DashboardCreationViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entitiesService: entityServiceInstance,
            mode: mode
        )
        DashboardCreationCoordinator(viewModel: viewModel)
    }
}
