//
//  EmptyCodable.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct EmptyCodable: Codable {
    public init() {}
}

public extension EmptyCodable {
    static let `nil`: EmptyCodable? = nil
}
