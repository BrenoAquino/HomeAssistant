//
//  CoordinatorView.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

struct CoordinatorView: View {

    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var coordinator = Coordinator(root: Factory.shared.launchScreen())

    var body: some View {
        viewWithBlockIfNeeded {
            NavigationStack(path: $coordinator.path) {
                coordinator.root.view
                    .opacityTransition()
                    .navigationDestination(for: Screen2.self) { screen in
                        let _ = print(screen)
                        viewWithBlockIfNeeded { screen.view }
                    }
                    .sheet(item: $coordinator.sheet) { screen in
                        viewWithBlockIfNeeded { screen.view }
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { screen in
                        viewWithBlockIfNeeded { screen.view }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environmentObject(coordinator)
    }

    private func viewWithBlockIfNeeded(@ViewBuilder _ content: () -> some View) -> some View {
        ZStack {
            content()

            if let block = coordinator.block {
                block.view
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
