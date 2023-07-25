//
//  Screen.swift
//  Home
//
//  Created by Breno Aquino on 24/07/23.
//

import SwiftUI

// MARK: PresentationStyle

extension PresentationStyle {
    static let `default`: PresentationStyle = .init(transition: nil)
    static let opacity: PresentationStyle = .init(transition: .opacity)
    static let none: PresentationStyle = .init(transition: .none)
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
    func style(_ style: PresentationStyle?) -> some View {
        if let style = style?.transition {
            transition(style)
        } else {
            self
        }
    }
}
