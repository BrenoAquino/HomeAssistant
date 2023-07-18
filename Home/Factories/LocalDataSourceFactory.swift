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

    init(databaseProvider: DatabaseProvider) {
        dashboardLocalDateSource = DashboardLocalDataSourceImpl(databaseProvider: databaseProvider)
    }

    func dashboard() -> DashboardLocalDataSource {
        dashboardLocalDateSource
    }
}
