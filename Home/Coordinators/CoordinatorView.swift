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
        ZStack {
            NavigationStack(path: $coordinator.path) {
                coordinator.rootView()
                    .opacityTransition()
                    .navigationDestination(for: Screen.self, destination: { coordinator.build(screen: $0) })
                    .sheet(item: $coordinator.sheet, content: { coordinator.build(screen: $0) })
                    .fullScreenCover(item: $coordinator.fullScreenCover, content: { coordinator.build(screen: $0) })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let block = coordinator.block {
                coordinator.build(screen: block)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacityTransition()
            }
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
}
