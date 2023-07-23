//
//  LocalDataSourceFactory.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import Data
import Foundation

protocol LocalDataSourceFactory {

    func dashboardLocalDataSource() -> DashboardLocalDataSource
}
