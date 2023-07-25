//
//  CoordinatorView.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

struct CoordinatorView: View {

    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var coordinator = Coordinator()

    var body: some View {
        viewWithBlockIfNeeded {
            NavigationStack(path: $coordinator.path) {
                coordinator.rootView()
                    .opacityTransition()
                    .navigationDestination(for: Screen.self, destination: { coordinator.build(screen: $0) })
                    .sheet(item: $coordinator.sheet) { screen in
                        viewWithBlockIfNeeded { coordinator.build(screen: screen) }
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { screen in
                        viewWithBlockIfNeeded { coordinator.build(screen: screen) }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environmentObject(coordinator)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                coordinator.lifeCycleHandler.appStateDidChange(.foreground)
            case .inactive, .background:
                coordinator.lifeCycleHandler.appStateDidChange(.background)
            @unknown default:
                break
            }
        }
    }

    private func viewWithBlockIfNeeded(@ViewBuilder _ content: () -> some View) -> some View {
        ZStack {
            content()

            if let block = coordinator.block {
                coordinator.build(screen: block)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
