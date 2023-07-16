//
//  Decodable+jsonData.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public extension Decodable {

    init(jsonData: Data) throws {
        let header = try JSONDecoder().decode(Self.self, from: jsonData)
        self = header
    }
}
