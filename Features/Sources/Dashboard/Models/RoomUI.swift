//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

class RoomUI {

    let name: String
    let icon: String

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
}

// MARK: Identifiable

extension RoomUI: Identifiable {
    var id: String { name }
}
