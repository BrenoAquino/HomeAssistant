//
//  CommandRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol CommandRemoteDataSource {

    func fireEvent(eventType: String, eventData: Encodable?) async throws
    func callService(domain: String, service: String, entityID: String, serviceData: Encodable?) async throws
}
