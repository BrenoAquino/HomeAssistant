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

    /// Hard - 16
    public static let hard: DSBlurRadius = DSBlurRadius(rawValue: 32)
    /// Normal - 8
    public static let normal: DSBlurRadius = DSBlurRadius(rawValue: 16)
    /// Easy - 4
    public static let easy: DSBlurRadius = DSBlurRadius(rawValue: 8)
}

// MARK: - SwiftUI

public extension RoundedRectangle {

    init(cornerRadius: DSRadius, style: RoundedCornerStyle = .circular) {
        self.init(cornerRadius: cornerRadius.rawValue, style: style)
    }
}

public extension View {

    func blur(radius: DSBlurRadius, opaque: Bool = false) -> some View {
        blur(radius: radius.rawValue, opaque: opaque)
    }

    func cornerRadius(_ radius: DSRadius, antialiased: Bool = true) -> some View {
        cornerRadius(radius.rawValue, antialiased: antialiased)
    }
}
