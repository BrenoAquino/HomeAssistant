//
//  Factory.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Domain
import Data
import Launch
import Dashboard
import Config
import DashboardWizard
import Foundation
import SwiftUI

#if PREVIEW
import Preview
#endif

class Factory: ObservableObject {

    // MARK: Infrastructure

    private lazy var databaseProviderInstance = UserDefaultsDatabaseProvider()

    private lazy var webSocketProviderInstance = try! WebSocket(
        url: AppEnvironment.homeAssistantURL,
        token: AppEnvironment.authToken
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
    func staticLaunchScreen() -> Screen {
        Screen(view: StaticLaunchCoordinator())
    }

    func launchScreen() -> Screen {
        Screen(view: LaunchCoordinator(viewModel: LaunchViewModelImpl(
            entityService: entityServiceInstance,
            dashboardService: dashboardServiceInstance
        )))
    }

    func dashboardScreen() -> Screen {
        Screen(view: DashboardCoordinator(viewModel: DashboardViewModelImpl(
            dashboardService: dashboardServiceInstance,
            entityService: entityServiceInstance
        )))
    }

    func configScreen() -> Screen {
        Screen(view: ConfigCoordinator(viewModel: ConfigViewModelImpl(
            entityService: entityServiceInstance
        )))
    }

    func dashboardWizardScreen(mode: DashboardWizardMode) -> Screen {
        Screen(view: DashboardWizardCoordinator(viewModel: DashboardWizardViewModelImpl(
            dashboardService: dashboardServiceInstance,
            mode: mode
        )))
    }

//    func widgetEdit(dashboard: Domain.Dashboard, mode: WidgetEditMode) -> Screen {
//        Screen(view: WidgetEditCoordinator(viewModel: WidgetEditViewModelImpl(
//            dashboardService: dashboardServiceInstance,
//            entityService: entityServiceInstance,
//            mode: mode,
//            dashboard: dashboard
//        )))
//    }
}

// MARK: Handlers

extension Factory: ManagerFactory {
    func webSocketManager(coordinator: Coordinator) -> WebSocketManager {
        WebSocketManagerImpl(
            coordinator: coordinator,
            webSocketProvider: webSocketProviderInstance
        )
    }
}
