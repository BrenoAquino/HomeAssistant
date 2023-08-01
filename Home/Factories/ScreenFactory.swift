//
//  ScreenFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Foundation
import DashboardCreation

protocol ScreenFactory {

    func launchScreen() -> Screen
    func staticLaunchScreen() -> Screen
    func dashboardScreen() -> Screen
    func dashboardCreationScreen(mode: DashboardCreationMode) -> Screen
    func configScreen() -> Screen
}
