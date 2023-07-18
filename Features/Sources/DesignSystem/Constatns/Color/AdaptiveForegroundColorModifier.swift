//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

public struct AdaptiveForegroundColorModifier: ViewModifier {

    var color: AdaptiveColor

    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> some View {
        content.foregroundColor(resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light:
            return Color(color.schema.light)
        case .dark:
            return Color(color.schema.dark)
        @unknown default:
            return Color(color.schema.light)
        }
    }
}

public struct AdaptiveBackgroundColorModifier: ViewModifier {

    var color: AdaptiveColor

    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> some View {
        content.background(resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light:
            return Color(color.schema.light)
        case .dark:
            return Color(color.schema.dark)
        @unknown default:
            return Color(color.schema.light)
        }
    }
}

public extension View {
    func foregroundColor(color: AdaptiveColor) -> some View {
        modifier(AdaptiveForegroundColorModifier(color: color))
    }

    func background(color: AdaptiveColor) -> some View {
        modifier(AdaptiveBackgroundColorModifier(color: color))
    }
}
