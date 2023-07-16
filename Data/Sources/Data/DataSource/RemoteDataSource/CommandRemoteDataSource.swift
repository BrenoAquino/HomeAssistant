//
//  CommandRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol CommandRemoteDataSource {

    func fireEvent<T: Encodable>(eventType: String, eventData: T?) async throws
    func callService<T: Encodable>(domain: String, service: String, entityID: String?, serviceData: T?) async throws
}
