//
//  DSRadius.swift
//  
//
//  Created by Breno Aquino on 16/06/23.
//

import Foundation
import SwiftUI

public struct DSRadius {
    public let rawValue: CGFloat

    private init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /// Hard - 16
    public static let hard: DSRadius = DSRadius(rawValue: 16)
    /// Normal - 8
    public static let normal: DSRadius = DSRadius(rawValue: 8)
    /// Easy - 4
    public static let easy: DSRadius = DSRadius(rawValue: 4)
}

public struct DSBlurRadius {
    public let rawValue: CGFloat

    private init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /// Hard - 32
    public static let hard: DSBlurRadius = DSBlurRadius(rawValue: 32)
    /// Normal - 16
    public static let normal: DSBlurRadius = DSBlurRadius(rawValue: 16)
    /// Easy - 8
    public static let easy: DSBlurRadius = DSBlurRadius(rawValue: 8)
}

public struct DSShadowRadius {
    public let rawValue: CGFloat

    private init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /// Hard - 32
    public static let hard: DSShadowRadius = DSShadowRadius(rawValue: 32)
    /// Normal - 16
    public static let normal: DSShadowRadius = DSShadowRadius(rawValue: 16)
    /// Easy - 8
    public static let easy: DSShadowRadius = DSShadowRadius(rawValue: 8)
    /// Very Easy - 4
    public static let veryEasy: DSShadowRadius = DSShadowRadius(rawValue: 4)
}

// MARK: - SwiftUI

public extension RoundedRectangle {

    init(cornerRadius: DSRadius, style: RoundedCornerStyle = .circular) {
        self.init(cornerRadius: cornerRadius.rawValue, style: style)
    }
}

public extension View {

    func shadow(radius: DSShadowRadius, color: Color = .black.opacity(0.33), x: CGFloat = .zero, y: CGFloat = .zero) -> some View {
        shadow(color: color, radius: radius.rawValue, x: x, y: y)
    }

    func blur(radius: DSBlurRadius, opaque: Bool = false) -> some View {
        blur(radius: radius.rawValue, opaque: opaque)
    }

    func cornerRadius(_ radius: DSRadius, antialiased: Bool = true) -> some View {
        cornerRadius(radius.rawValue, antialiased: antialiased)
    }
}
