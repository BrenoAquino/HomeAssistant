//
//  CommandRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Common
import Foundation

public protocol CommandRepository {

    func callService(entityID: String, service: EntityActionService) async throws
    func callService(domain: EntityDomain, service: EntityActionService) async throws
}
