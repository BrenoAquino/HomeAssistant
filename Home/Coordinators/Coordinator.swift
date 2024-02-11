//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Coordinator: ObservableObject {
    /// Factory to get the instances with their dependencies already injected
    private let factory: Factory = .init()

    // MARK: Handlers
    /// WebSocket handler
    private lazy var managers: [Manager] = [
        factory.webSocketManager(coordinator: self),
    ]

    // MARK: Publishers
    /// The main screen, the started one
    @Published var root: Screen
    /// An screen that could be called to be present over the others
    @Published var block: Screen?
    /// A stack of screens to be placed over the root
    @Published var path = NavigationPath()
    /// A screen which would be present as a sheet (it will not stack on path)
    @Published var sheet: Screen?
    /// A screen which would be present as a full cover (it will not stack on path)
    @Published var fullScreenCover: Screen?

    // MARK: Cache

    init(root: ScreenDestination) {
        self.root = root.screen(factory: factory)
        startManagers()
    }

    /// Called when the first screen appears and the app loads
    func startManagers() {
        managers.forEach { $0.start() }
    }
}

// MARK: Present

extension Coordinator {
    /// Set the root screen (it will not change anything on the stack)
    func setRoot(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.root = destination.screen(factory: factory)
        }
    }
    /// Set a screen to be over everything
    func setBlock(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.block = destination.screen(factory: factory)
        }
    }
    /// Stack and show a new screen
    func push(_ destination: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.path.append(destination.screen(factory: factory))
        }
    }
    /// Present a screen on sheet style
    func preset(sheet: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.sheet = sheet.screen(factory: factory)
        }
    }
    /// Present a screen on full cover style
    func preset(fullScreenCover: ScreenDestination) {
        DispatchQueue.main.async { [self] in
            self.fullScreenCover = fullScreenCover.screen(factory: factory)
        }
    }
}

// MARK: Dismiss

extension Coordinator {
    /// Dismiss the last screen on the stack (path)
    func pop() {
        DispatchQueue.main.async { [self] in
            self.path.removeLast()
        }
    }
    /// Dismiss all screens on the stack (path)
    func popToRoot() {
        DispatchQueue.main.async { [self] in
            self.path.removeLast(path.count)
        }
    }
    /// Dismiss the sheet or full cover screen
    func dismiss() {
        DispatchQueue.main.async { [self] in
            self.sheet = nil
            self.fullScreenCover = nil
        }
    }
    /// Dismiss the block screen
    func dismissBlock() {
        DispatchQueue.main.async { [self] in
            self.block = nil
        }
    }
}
