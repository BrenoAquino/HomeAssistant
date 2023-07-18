//
//  DatabaseProvider.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DatabaseProvider {

    func save<T: Encodable>(key: String, data: T) async throws
    func load<T: Decodable>(key: String) async throws -> T
}
