//
//  CoordinatorView.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

struct CoordinatorView: View {

    @ObservedObject private var coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView()
                .opacityTransition()
                .navigationDestination(for: Screen.self, destination: { coordinator.build(screen: $0) })
                .sheet(item: $coordinator.sheet, content: { coordinator.build(sheet: $0) })
                .fullScreenCover(item: $coordinator.fullScreenCover, content: { coordinator.build(fullScreenCover: $0) })
        }
        .environmentObject(coordinator)
    }
}
