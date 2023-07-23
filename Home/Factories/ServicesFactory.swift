//
//  ServicesFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

protocol ServicesFactory {

    func configService() -> ConfigService
    func entityService() -> any EntityService
    func dashboardService() -> any DashboardService
}
