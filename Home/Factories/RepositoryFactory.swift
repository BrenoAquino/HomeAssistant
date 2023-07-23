//
//  RepositoryFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Data
import Domain
import Foundation

protocol RepositoryFactory {

    func commandRepository() -> CommandRepository
    func fetcherRepository() -> FetcherRepository
    func subscriptionRepository() -> SubscriptionRepository
    func dashboardRepository() -> DashboardRepository
}
