//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

struct PresentationStyle {

    let transition: AnyTransition?
}

extension PresentationStyle {

    static let `default`: PresentationStyle = .init(
        transition: .opacity.animation(.linear(duration: 0.3))
    )

    static let none: PresentationStyle = .init(
        transition: .none
    )
}

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

// MARK: View

extension View {

    @ViewBuilder
    private func transitionIfExist(_ style: PresentationStyle?) -> some View {
        if let styleTransition = style?.transition {
            self.transition(styleTransition)
        } else {
            self
        }
    }

    @ViewBuilder
    func style(_ style: PresentationStyle?) -> some View {
        self
            .transitionIfExist(style)
    }
}
