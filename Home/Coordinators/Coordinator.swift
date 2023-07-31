//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Coordinator: ObservableObject {

    // MARK: Publishers

    @Published var root: Screen2
    @Published var block: Screen2?
    @Published var path = NavigationPath()
    @Published var sheet: Screen2?
    @Published var fullScreenCover: Screen2?

    // MARK: Cache

    init(root: Screen2) {
        self.root = root
    }
}

// MARK: Present

extension Coordinator {

    func setRoot(_ screen: Screen2) {
        DispatchQueue.main.async { [self] in
            self.root = screen
        }
    }

    func block(_ screen: Screen2) {
        DispatchQueue.main.async { [self] in
            self.block = screen
        }
    }

    func push(_ screen: Screen2) {
        DispatchQueue.main.async { [self] in
            self.path.append(screen)
        }
    }

    func preset(sheet: Screen2) {
        DispatchQueue.main.async { [self] in
            self.sheet = sheet
        }
    }

    func preset(fullScreenCover: Screen2) {
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
