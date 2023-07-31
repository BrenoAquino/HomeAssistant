//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI
import DashboardCreation

class Screen2: Identifiable {

    let id: UUID
    let view: AnyView

    init(view: any View) {
        self.id = .init()
        self.view = AnyView(view)
    }
}

extension Screen2: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Screen2, rhs: Screen2) -> Bool {
        lhs.id == rhs.id
    }
}
