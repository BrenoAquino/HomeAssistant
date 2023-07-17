//
//  Coordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Launch
import Dashboard

enum Screen: String, Identifiable {
    case launch
    case dashboard

    var id: String { rawValue }
}

enum Sheet: String, Identifiable {
    case example

    var id: String { rawValue }
}

enum FullScreenCover: String, Identifiable {
    case example

    var id: String { rawValue }
}

// MARK: Coordinator

class Coordinator: ObservableObject {

    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
}

// MARK: Present

extension Coordinator {

    func push(_ screen: Screen) {
        path.append(screen)
    }

    func preset(sheet: Sheet) {
        self.sheet = sheet
    }

    func preset(fullScreenCover: FullScreenCover) {
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
    func build(screen: Screen) -> some View {
        switch screen {
        case .launch:
            Text("1")
        case .dashboard:
            Text("2")
        }
    }

    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        Text("3")
    }

    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        Text("4")
    }
}
