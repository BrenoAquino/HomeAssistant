//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Coordinator: ObservableObject {

    private lazy var factory: Factory = .init(webSocketDidDisconnect: { [weak self] in
        self?.webSocketHandler.webSocketDidDisconnect()
    })

    // MARK: Handlers

    private(set) lazy var lifeCycleHandler = factory.lifeCycleHandler(coordinator: self)
    private(set) lazy var webSocketHandler = factory.webSocketHandler(coordinator: self)

    // MARK: Publishers

    @Published var root: Screen = Screen.launch(style: .default)
    @Published var block: Screen?

    @Published var path = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?
}

// MARK: Present

extension Coordinator {

    func setRoot(_ screen: Screen) {
        DispatchQueue.main.async { [self] in
            self.root = screen
        }
    }

    func block(_ screen: Screen) {
        DispatchQueue.main.async { [self] in
            self.block = screen
        }
    }

    func push(_ screen: Screen) {
        DispatchQueue.main.async { [self] in
            self.path.append(screen)
        }
    }

    func preset(sheet: Screen) {
        DispatchQueue.main.async { [self] in
            self.sheet = sheet
        }
    }

    func preset(fullScreenCover: Screen) {
        DispatchQueue.main.async { [self] in
            self.fullScreenCover = fullScreenCover
        }
    }
}

// MARK: Dismiss

extension Coordinator {

    func pop() {
        DispatchQueue.main.async { [self] in
            self.path.removeLast()
        }
    }

    func popToRoot() {
        DispatchQueue.main.async { [self] in
            self.path.removeLast(path.count)
        }
    }

    func dismiss() {
        DispatchQueue.main.async { [self] in
            self.sheet = nil
            self.fullScreenCover = nil
        }
    }

    func dismissBlock() {
        DispatchQueue.main.async { [self] in
            self.block = nil
        }
    }
}

// MARK: Builds

extension Coordinator {

    @ViewBuilder
    func rootView() -> some View {
        root.viewCoordinator(factory).style(root.style)
    }

    @ViewBuilder
    func build(screen: Screen) -> some View {
        screen.viewCoordinator(factory).style(screen.style)
    }
}
