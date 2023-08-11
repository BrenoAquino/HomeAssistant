//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Coordinator: ObservableObject {

    private let factory: Factory = .init()

    // MARK: Handlers

    private lazy var webSocketHandler = factory.webSocketHandler(coordinator: self)

    // MARK: Publishers

    @Published var root: Screen
    @Published var block: Screen?
    @Published var path = NavigationPath()
    @Published var sheet: Screen?
    @Published var fullScreenCover: Screen?

    // MARK: Cache

    init(root: ScreenDestination) {
        self.root = root.screen(factory: factory)
    }

    func startHandlers() {
        webSocketHandler.start()
    }
}

// MARK: Present

extension Coordinator {

    func setRoot(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.root = destination.screen(factory: factory)
        }
    }

    func setBlock(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.block = destination.screen(factory: factory)
        }
    }

    func push(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.path.append(destination.screen(factory: factory))
        }
    }

    func preset(sheet: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.sheet = sheet.screen(factory: factory)
        }
    }

    func preset(fullScreenCover: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.fullScreenCover = fullScreenCover.screen(factory: factory)
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
