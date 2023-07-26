//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 24/07/23.
//

import SwiftUI

// MARK: PresentationStyle

struct EmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension PresentationStyle {
    static let `default`: PresentationStyle = .init(
        transition: .opacity.animation(.linear(duration: 0.3))
    )

    static let none: PresentationStyle = .init(
        transition: .none
    )
}

// MARK: Screen

extension Screen {

    var id: String { String(describing: self) }
    var style: PresentationStyle? {
        guard let enumParamsReflection = Mirror(reflecting: self).children.first?.value else {
            return nil
        }
        for value in Mirror(reflecting: enumParamsReflection).children {
            if let style = value.value as? PresentationStyle {
                return style
            }
        }
        return nil
    }
}

extension Screen {

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
