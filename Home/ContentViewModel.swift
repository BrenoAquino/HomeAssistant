//
//  ContentViewModel.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Data
import Foundation

class ContentViewModel: ObservableObject {

    private let webSocket: WebSocketProvider
    private let remoteDataSourceFactory: RemoteDataSourceFactory
    private let repositoryFactory: RepositoryFactory
    private let servicesFactory: ServicesFactory
    private let viewModelFactory: ViewModelFactory
    let coordinatorFactory: CoordinatorFactory

    init() {
        webSocket = try! WebSocket(url: Environment.homeAssistantURL, token: Environment.authToken)
        remoteDataSourceFactory = RemoteDataSourceFactory(webSocketProvider: webSocket)
        repositoryFactory = RepositoryFactory(remoteDataSourceFactory: remoteDataSourceFactory)
        servicesFactory = ServicesFactory(repositoryFactory: repositoryFactory)
        viewModelFactory = ViewModelFactory(servicesFactory: servicesFactory)
        coordinatorFactory = CoordinatorFactory(viewModelFactory: viewModelFactory)
    }
}
