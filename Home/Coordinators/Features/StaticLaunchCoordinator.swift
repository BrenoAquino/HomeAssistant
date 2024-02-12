//
//  StaticLaunchCoordinator.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import Launch

struct StaticLaunchCoordinator: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        StaticLaunchView()
    }
}
