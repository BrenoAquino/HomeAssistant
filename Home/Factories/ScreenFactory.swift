//
//  ScreenFactory.swift
//  Home
//
//  Created by Breno Aquino on 31/07/23.
//

import Domain
import Foundation
import DashboardWizard
//import WidgetEdit

protocol ScreenFactory {
    func launchScreen() -> Screen
    func staticLaunchScreen() -> Screen
    func dashboardScreen() -> Screen
    func configScreen() -> Screen
    func dashboardWizardScreen(mode: DashboardWizardMode) -> Screen
//    func widgetEdit(dashboard: Domain.Dashboard, mode: WidgetEditMode) -> Screen
}
