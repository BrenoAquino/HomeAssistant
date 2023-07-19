//
//  RemoteDataSourceFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Data
import Foundation

class RemoteDataSourceFactory {

    private let commandRemoteDateSource: CommandRemoteDataSource
    private let fetcherRemoteDateSource: FetcherRemoteDataSource
    private let subscriptionRemoteDateSource: SubscriptionRemoteDataSource

    init(infrastructureFactory: InfrastructureFactory) {
        commandRemoteDateSource = CommandRemoteDataSourceImpl(webSocketProvider: infrastructureFactory.webSocket())
        fetcherRemoteDateSource = FetcherRemoteDataSourceImpl(webSocketProvider: infrastructureFactory.webSocket())
        subscriptionRemoteDateSource = SubscriptionRemoteDataSourceImpl(webSocketProvider: infrastructureFactory.webSocket())
    }

    func command() -> CommandRemoteDataSource {
        commandRemoteDateSource
    }

    func fetcher() -> FetcherRemoteDataSource {
        fetcherRemoteDateSource
    }

    func subscription() -> SubscriptionRemoteDataSource {
        subscriptionRemoteDateSource
    }
}
