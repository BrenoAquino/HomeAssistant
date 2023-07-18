//
//  RepositoryFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Data
import Domain
import Foundation

class RepositoryFactory {

    private let commandRepository: CommandRepository
    private let fetcherRepository: FetcherRepository
    private let subscriptionRepository: SubscriptionRepository
    private let dashboardRepository: DashboardRepository

    init(localDataSourceFactory: LocalDataSourceFactory, remoteDataSourceFactory: RemoteDataSourceFactory) {
        commandRepository = CommandRepositoryImpl(commandRemoteDataSource: remoteDataSourceFactory.command())
        fetcherRepository = FetcherRepositoryImpl(fetcherRemoteDataSource: remoteDataSourceFactory.fetcher())
        subscriptionRepository = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: remoteDataSourceFactory.subscription())
        dashboardRepository = DashboardRepositoryImpl(dashboardLocalDataSource: localDataSourceFactory.dashboard())
    }

    func command() -> CommandRepository {
        commandRepository
    }

    func fetcher() -> FetcherRepository {
        fetcherRepository
    }

    func subscription() -> SubscriptionRepository {
        subscriptionRepository
    }

    func dashboard() -> DashboardRepository {
        dashboardRepository
    }
}
