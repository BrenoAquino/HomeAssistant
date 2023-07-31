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

    static let shared: Factory = .init()

    private init() {}

    // MARK: Infrastructure

    private lazy var databaseProviderInstance = UserDefaultsDatabaseProvider()

    private lazy var webSocketProviderInstance = try! WebSocket(
        url: AppEnvironment.homeAssistantURL,
        token: AppEnvironment.authToken,
        didDisconnect: nil
    )

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

// MARK: Screens

extension Factory {

    func launchScreen() -> Screen2 {
        let viewModel = LaunchViewModelImpl(
            entityService: entityServiceInstance,
            dashboardService: dashboardServiceInstance
        )
        return Screen2(view: LaunchCoordinator(viewModel: viewModel))
    }

    func staticLaunchScreen() -> Screen2 {
        return Screen2(view: StaticLaunchCoordinator())
    }

    func dashboardScreen() -> Screen2 {
        let viewModel = DashboardViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entityService: entityServiceInstance
        )
        return Screen2(view: DashboardCoordinator(viewModel: viewModel))
    }

    func dashboardCreationScreen(mode: DashboardCreationMode) -> Screen2 {
        let viewModel = DashboardCreationViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entitiesService: entityServiceInstance,
            mode: mode
        )
        return Screen2(view: DashboardCreationCoordinator(viewModel: viewModel))
    }

    func configScreen() -> Screen2 {
        let viewModel = ConfigViewModelImpl(entityService: entityServiceInstance)
        return Screen2(view: ConfigCoordinator(viewModel: viewModel))
    }
}
