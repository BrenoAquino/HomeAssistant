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

    private lazy var databaseProviderInstance = UserDefaultsDatabaseProvider()

    private var webSocketProviderInstance: WebSocketProvider

    // MARK: LocalDataSource

    private lazy var dashboardLocalDataSourceInstance = DashboardLocalDataSourceImpl(
        databaseProvider: databaseProviderInstance
    )

    private lazy var entityLocalDataSourceInstance = EntityLocalDataSourceImpl(
        databaseProvider: databaseProviderInstance
    )

    // MARK: RemoteDataSource

    private lazy var commandRemoteDataSourceInstance = CommandRemoteDataSourceImpl(
        webSocketProvider: webSocketProviderInstance
    )

    private lazy var fetcherRemoteDataSourceInstance = FetcherRemoteDataSourceImpl(
        webSocketProvider: webSocketProviderInstance
    )

    private lazy var subscriptionRemoteDataSourceInstance = SubscriptionRemoteDataSourceImpl(
        webSocketProvider: webSocketProviderInstance
    )

    // MARK: Repositories

    private lazy var commandRepositoryInstance = CommandRepositoryImpl(
        commandRemoteDataSource: commandRemoteDataSourceInstance
    )

    private lazy var subscriptionRepositoryInstance = SubscriptionRepositoryImpl(
        subscriptionRemoteDataSource: subscriptionRemoteDataSourceInstance
    )

    private lazy var dashboardRepositoryInstance = DashboardRepositoryImpl(
        dashboardLocalDataSource: dashboardLocalDataSourceInstance
    )

    private lazy var serverRepositoryInstance = ServerRepositoryImpl(
        fetcherRemoteDataSource: fetcherRemoteDataSourceInstance
    )

    private lazy var entityRepositoryInstance = EntityRepositoryImpl(
        entityLocalDataSource: entityLocalDataSourceInstance,
        fetcherRemoteDataSource: fetcherRemoteDataSourceInstance
    )

    // MARK: Services

    private lazy var configServiceInstance = ConfigServiceImpl(
        serverRepository: serverRepositoryInstance
    )

    private lazy var dashboardServiceInstance = DashboardServiceImpl(
        dashboardRepository: dashboardRepositoryInstance
    )

    private lazy var entityServiceInstance = EntityServiceImpl(
        entityRepository: entityRepositoryInstance,
        commandRepository: commandRepositoryInstance,
        subscriptionRepository: subscriptionRepositoryInstance
    )

    // MARK: Init

    init(webSocketDidDisconnect: (() -> Void)? = nil) {
        webSocketProviderInstance = try! WebSocket(
            url: AppEnvironment.homeAssistantURL,
            token: AppEnvironment.authToken,
            didDisconnect: webSocketDidDisconnect
        )
    }
}

// MARK: Coordinator

extension Factory {

    @ViewBuilder
    func launchCoordinator() -> some View {
        let viewModel = LaunchViewModelImpl(
            entityService: entityServiceInstance,
            dashboardService: dashboardServiceInstance
        )
        LaunchCoordinator(viewModel: viewModel)
    }

    @ViewBuilder
    func staticLaunchCoordinator() -> some View {
        StaticLaunchCoordinator()
    }

    @ViewBuilder
    func dashboardCoordinator() -> some View {
        let viewModel = DashboardViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entityService: entityServiceInstance
        )
        DashboardCoordinator(viewModel: viewModel)
    }

    @ViewBuilder
    func dashboardCreationCoordinator(mode: DashboardCreationMode) -> some View {
        let viewModel = DashboardCreationViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entitiesService: entityServiceInstance,
            mode: mode
        )
        DashboardCreationCoordinator(viewModel: viewModel)
    }

    @ViewBuilder
    func configCoordinator() -> some View {
        let viewModel = ConfigViewModelImpl(entityService: entityServiceInstance)
        ConfigCoordinator(viewModel: viewModel)
    }
}

// MARK: Handlers

extension Factory {

    func webSocketHandler(coordinator: Coordinator) -> WebSocketHandler {
        WebSocketHandlerImpl(coordinator: coordinator)
    }
}
