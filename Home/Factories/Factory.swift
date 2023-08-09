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
import DashboardEdit
import Foundation
import SwiftUI
import Config
import WidgetEdit

#if PREVIEW
import Preview
#endif

class Factory: ObservableObject {

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

#if PREVIEW
    private lazy var configServiceInstance = ConfigServiceMock()
#else
    private lazy var configServiceInstance = ConfigServiceImpl(
        serverRepository: serverRepositoryInstance
    )
#endif

#if PREVIEW
    private lazy var dashboardServiceInstance = DashboardServiceMock()
#else
    private lazy var dashboardServiceInstance = DashboardServiceImpl(
        dashboardRepository: dashboardRepositoryInstance
    )
#endif

#if PREVIEW
    private lazy var entityServiceInstance = EntityServiceMock()
#else
    private lazy var entityServiceInstance = EntityServiceImpl(
        entityRepository: entityRepositoryInstance,
        commandRepository: commandRepositoryInstance,
        subscriptionRepository: subscriptionRepositoryInstance
    )
#endif
}

// MARK: Screens

extension Factory: ScreenFactory {

    func launchScreen() -> Screen {
        let viewModel = LaunchViewModelImpl(
            entityService: entityServiceInstance,
            dashboardService: dashboardServiceInstance
        )
        return Screen(view: LaunchCoordinator(viewModel: viewModel))
    }

    func staticLaunchScreen() -> Screen {
        return Screen(view: StaticLaunchCoordinator())
    }

    func dashboardScreen() -> Screen {
        let viewModel = DashboardViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entityService: entityServiceInstance
        )
        return Screen(view: DashboardCoordinator(viewModel: viewModel))
    }

    func dashboardEditScreen(mode: DashboardEditMode) -> Screen {
        let viewModel = DashboardEditViewModelImpl(
            dashboardService: dashboardServiceInstance,
            mode: mode
        )
        return Screen(view: DashboardEditCoordinator(viewModel: viewModel))
    }

    func widgetEdit(dashboard: Domain.Dashboard, mode: WidgetEditMode) -> Screen {
        let viewModel = WidgetEditViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entityService: entityServiceInstance,
            dashboard: dashboard,
            mode: mode
        )
        return Screen(view: WidgetEditCoordinator(viewModel: viewModel))
    }

    func configScreen() -> Screen {
        let viewModel = ConfigViewModelImpl(entityService: entityServiceInstance)
        return Screen(view: ConfigCoordinator(viewModel: viewModel))
    }
}

// MARK: Handlers

extension Factory: HandlerFactory {

    func webSocketHandler(coordinator: Coordinator) -> WebSocketHandler {
        WebSocketHandlerImpl(coordinator: coordinator)
    }
}
