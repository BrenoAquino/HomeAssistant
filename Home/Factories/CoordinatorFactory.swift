//
//  CoordinatorFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import DashboardCreation
import Foundation
import SwiftUI

protocol CoordinatorFactory {

    func launchCoordinator<T: View>() -> T
    func dashboardCoordinator<T: View>() -> T
    func dashboardCreationCoordinator<T: View>(mode: DashboardCreationMode) -> T
}
