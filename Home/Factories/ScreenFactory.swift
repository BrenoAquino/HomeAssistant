//
//  ScreenFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Foundation
import DashboardEdit

protocol ScreenFactory {

    func launchScreen() -> Screen
    func staticLaunchScreen() -> Screen
    func dashboardScreen() -> Screen
    func dashboardEditScreen(mode: DashboardEditMode) -> Screen
    func configScreen() -> Screen
}
