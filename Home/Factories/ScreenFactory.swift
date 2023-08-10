//
//  ScreenFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Domain
import Foundation
import DashboardEdit
import WidgetEdit

protocol ScreenFactory {

    func launchScreen() -> Screen
    func staticLaunchScreen() -> Screen
    func dashboardScreen() -> Screen
    func dashboardEditScreen(mode: DashboardEditMode) -> Screen
    func widgetEdit(dashboard: Domain.Dashboard, mode: WidgetEditMode) -> Screen
    func configScreen() -> Screen
}
