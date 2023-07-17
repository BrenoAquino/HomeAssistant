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

    let commandRepository: CommandRepository
    let fetcherRepository: FetcherRepository
    let subscriptionRepository: SubscriptionRepository

    init(remoteDataSourceFactory: RemoteDataSourceFactory) {
        self.commandRepository = CommandRepositoryImpl(commandRemoteDataSource: remoteDataSourceFactory.command())
        self.fetcherRepository = FetcherRepositoryImpl(fetcherRemoteDataSource: remoteDataSourceFactory.fetcher())
        self.subscriptionRepository = SubscriptionRepositoryImpl(subscriptionRemoteDataSource: remoteDataSourceFactory.subscription())
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
}
