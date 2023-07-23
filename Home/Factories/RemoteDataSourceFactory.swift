//
//  RemoteDataSourceFactory.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Data
import Foundation

protocol RemoteDataSourceFactory {

    func commandRemoteDataSource() -> CommandRemoteDataSource
    func fetcherRemoteDataSource() -> FetcherRemoteDataSource
    func subscriptionRemoteDataSource() -> SubscriptionRemoteDataSource
}
