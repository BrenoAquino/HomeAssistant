//
//  StateRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

public protocol StateRemoteDataSource {

    func subscribeToStateChanged() async throws
    func fetchStates() async throws -> [EntityState]
}
