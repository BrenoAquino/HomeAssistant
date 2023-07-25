//
//  Factory.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Domain
import Data
import Dashboard
import Core
import DashboardCreation
import Foundation
import SwiftUI
import Config

class Factory {

    private let webSocketProviderInstance: WebSocketProvider
    private let databaseProviderInstance: DatabaseProvider

    private let dashboardLocalDataSourceInstance: DashboardLocalDataSource
    private let entityLocalDataSourceInstance: EntityLocalDataSource

    private let commandRemoteDataSourceInstance: CommandRemoteDataSource
    private let fetcherRemoteDataSourceInstance: FetcherRemoteDataSource
    private let subscriptionRemoteDataSourceInstance: SubscriptionRemoteDataSource

    private let commandRepositoryInstance: CommandRepository
    private let entityRepositoryInstance: EntityRepository
    private let serverRepositoryInstance: ServerRepository
    private let subscriptionRepositoryInstance: SubscriptionRepository
    private let dashboardRepositoryInstance: DashboardRepository

    private let configServiceInstance: ConfigServiceImpl
    private let entityServiceInstance: EntityServiceImpl
    private let dashboardServiceInstance: DashboardServiceImpl

    init() {
        webSocketProviderInstance = try! WebSocket(url: AppEnvironment.homeAssistantURL, token: AppEnvironment.authToken)
        databaseProviderInstance = UserDefaultsDatabaseProvider()

        dashboardLocalDataSourceInstance = DashboardLocalDataSourceImpl(databaseProvider: databaseProviderInstance)
        entityLocalDataSourceInstance = EntityLocalDataSourceImpl(databaseProvider: databaseProviderInstance)

        commandRemoteDataSourceInstance = CommandRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)
        fetcherRemoteDataSourceInstance = FetcherRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)
        subscriptionRemoteDataSourceInstance = SubscriptionRemoteDataSourceImpl(webSocketProvider: webSocketProviderInstance)

        commandRepositoryInstance = CommandRepositoryImpl(commandRemoteDataSource: commandRemoteDataSourceInstance)
        subscriptionRepositoryInstance = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: subscriptionRemoteDataSourceInstance)
        dashboardRepositoryInstance = DashboardRepositoryImpl(dashboardLocalDataSource: dashboardLocalDataSourceInstance)
        serverRepositoryInstance = ServerRepositoryImpl(fetcherRemoteDataSource: fetcherRemoteDataSourceInstance)
        entityRepositoryInstance = EntityRepositoryImpl(
            entityLocalDataSource: entityLocalDataSourceInstance,
            fetcherRemoteDataSource: fetcherRemoteDataSourceInstance
        )

        configServiceInstance = ConfigServiceImpl(serverRepository: serverRepositoryInstance)
        dashboardServiceInstance = DashboardServiceImpl(dashboardRepository: dashboardRepositoryInstance)
        entityServiceInstance = EntityServiceImpl(
            entityRepository: entityRepositoryInstance,
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

    func entityRepository() -> EntityRepository {
        entityRepositoryInstance
    }

    func serverRepository() -> ServerRepository {
        serverRepositoryInstance
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

    @ViewBuilder func getStaticLaunchCoordinator() -> some View {
        StaticLaunchCoordinator()
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

    @ViewBuilder func getConfigCoordinator() -> some View {
        let viewModel = ConfigViewModelImpl(entityService: entityServiceInstance)
        ConfigCoordinator(viewModel: viewModel)
    }
}

// MARK: Handlers

extension Factory {

    func lifeCycleHandler(coordinator: Coordinator) -> LifeCycleHandler {
        LifeCycleHandlerImpl(
            coordinator: coordinator,
            dashboardsService: dashboardServiceInstance,
            entityService: entityServiceInstance,
            webSocket: webSocketProviderInstance
        )
    }
}
