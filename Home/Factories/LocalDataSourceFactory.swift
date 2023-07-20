//
//  LocalDataSourceFactory.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import Data
import Foundation

class LocalDataSourceFactory {

    private let dashboardLocalDateSource: DashboardLocalDataSource

    init(infrastructureFactory: InfrastructureFactory) {
        dashboardLocalDateSource = DashboardLocalDataSourceImpl(databaseProvider: infrastructureFactory.database())
    }

    func dashboard() -> DashboardLocalDataSource {
        dashboardLocalDateSource
    }
}
