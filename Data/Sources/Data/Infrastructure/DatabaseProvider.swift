//
//  DatabaseProvider.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public protocol DatabaseProvider {
    /// Saves an encodable data object of generic type T to a specified key in storage, throwing an error if unsuccessful.
    func save<T: Encodable>(key: String, data: T) async throws
    /// Loads and decodes data of generic type T from storage using the provided key, throwing an error if unsuccessful.
    func load<T: Decodable>(key: String) async throws -> T
}
