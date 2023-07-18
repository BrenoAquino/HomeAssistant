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

    init(webSocketProvider: WebSocketProvider) {
        commandRemoteDateSource = CommandRemoteDataSourceImpl(webSocketProvider: webSocketProvider)
        fetcherRemoteDateSource = FetcherRemoteDataSourceImpl(webSocketProvider: webSocketProvider)
        subscriptionRemoteDateSource = SubscriptionRemoteDataSourceImpl(webSocketProvider: webSocketProvider)
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
