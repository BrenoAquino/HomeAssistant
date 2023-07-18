//
//  UserDefaultsDatabaseProvider.swift
//  Home
//
//  Created by Breno Aquino on 18/07/23.
//

import Data
import Foundation

enum UserDefaultsDatabaseProviderError: Error {
    case missingData
}

class UserDefaultsDatabaseProvider: DatabaseProvider {

    func save<T: Encodable>(key: String, data: T) async throws {
        let data = try JSONEncoder().encode(data)
        UserDefaults.standard.set(data, forKey: key)
    }

    func load<T: Decodable>(key: String) async throws -> T {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            throw UserDefaultsDatabaseProviderError.missingData
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
