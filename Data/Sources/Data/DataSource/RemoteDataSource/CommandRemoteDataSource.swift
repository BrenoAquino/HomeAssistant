//
//  CommandRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Common
import Foundation

public protocol CommandRemoteDataSource {

    func fireEvent(eventType: String) async throws
    func fireEvent<T: Encodable>(eventType: String, eventData: T?) async throws
    func callService(domain: String, service: String, entityID: String?) async throws
    func callService<T: Encodable>(domain: String, service: String, entityID: String?, serviceData: T?) async throws
}
