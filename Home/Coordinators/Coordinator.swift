//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Coordinator: ObservableObject {

    // MARK: Factories

    private lazy var infrastructureFactory = InfrastructureFactory()
    private lazy var localDataSourceFactory = LocalDataSourceFactory(infrastructureFactory: infrastructureFactory)
    private lazy var remoteDataSourceFactory = RemoteDataSourceFactory(infrastructureFactory: infrastructureFactory)
    private lazy var repositoryFactory = RepositoryFactory(
        localDataSourceFactory: localDataSourceFactory,
        remoteDataSourceFactory: remoteDataSourceFactory
    )
    private lazy var servicesFactory = ServicesFactory(repositoryFactory: repositoryFactory)
    private lazy var viewModelFactory = ViewModelFactory(servicesFactory: servicesFactory)
    private lazy var coordinatorFactory = CoordinatorFactory(viewModelFactory: viewModelFactory)

    // MARK: Publishers

    @Published var root = Screen.launch
    @Published var path = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
}

// MARK: Present

extension Coordinator {

    func push(_ screen: Screen) {
        path.append(screen)
    }

    func preset(sheet: Screen) {
        self.sheet = sheet
    }

    func preset(fullScreenCover: Screen) {
        self.fullScreenCover = fullScreenCover
    }
}

// MARK: Dismiss

extension Coordinator {

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func dismiss() {
        sheet = nil
        fullScreenCover = nil
    }
}

// MARK: Builds

extension Coordinator {

    @ViewBuilder
    func rootView() -> some View {
        root.viewCoordinator(coordinatorFactory)
    }

    @ViewBuilder
    func build(screen: Screen) -> some View {
        screen.viewCoordinator(coordinatorFactory)
    }

    @ViewBuilder
    func build(sheet: Screen) -> some View {
        sheet.viewCoordinator(coordinatorFactory)
    }

    @ViewBuilder
    func build(fullScreenCover: Screen) -> some View {
        fullScreenCover.viewCoordinator(coordinatorFactory)
    }
}
