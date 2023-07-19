//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public class Dashboard {

    public var name: String
    public var icon: String
    public var entities: [Entity]

    internal var entitiesIDs: [String]

    public init(name: String, icon: String, entities: [String] = []) {
        self.name = name
        self.icon = icon
        self.entitiesIDs = entities
        self.entities = []
    }

    public init(name: String, icon: String, entities: [Entity]) {
        self.name = name
        self.icon = icon
        self.entities = entities
        self.entitiesIDs = entities.map { $0.id } 
    }
}

// MARK: - Hashable

extension Dashboard: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    public static func == (lhs: Dashboard, rhs: Dashboard) -> Bool {
        lhs.name == rhs.name
    }
}
