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
            return color.color.light
        case .dark:
            return color.color.dark
        @unknown default:
            return color.color.light
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
            return color.color.light
        case .dark:
            return color.color.dark
        @unknown default:
            return color.color.light
        }
    }
}

public struct AdaptiveColorModifier<T: View>: ViewModifier {

    var color: AdaptiveColor
    @ViewBuilder var modifier: (_ content: any View, _ color: Color) -> T

    @Environment(\.colorScheme) private var colorScheme

    public func body(content: Content) -> T {
        modifier(content, resolvedColor)
    }

    private var resolvedColor: Color {
        switch colorScheme {
        case .light:
            return color.color.light
        case .dark:
            return color.color.dark
        @unknown default:
            return color.color.light
        }
    }
}

public extension View {
    func foregroundColor(color: AdaptiveColor) -> some View {
        modifier(AdaptiveColorModifier(
            color: .background,
            modifier: { content, color in
                AnyView(content.foregroundColor(color))
            }
        ))
    }

    func background(color: AdaptiveColor) -> some View {
        modifier(AdaptiveColorModifier(
            color: .background,
            modifier: { content, color in
                AnyView(content.background(color))
            }
        ))
    }
}
