//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

class Screen: Identifiable {
    let id: UUID
    let view: AnyView

    init(view: any View) {
        self.id = .init()
        self.view = AnyView(view)
    }
}

extension Screen: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}
