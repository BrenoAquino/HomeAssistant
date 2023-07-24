//
//  DSSpace.swift
//  
//
//  Created by Breno Aquino on 16/06/23.
//

import Foundation
import SwiftUI

public struct DSSpace {
    public let rawValue: CGFloat

    private init(rawValue: CGFloat) {
        self.rawValue = rawValue
    }

    /// Big Large - 40
    public static let bigL: DSSpace = DSSpace(rawValue: 40)
    /// Big Medium - 32
    public static let bigM: DSSpace = DSSpace(rawValue: 32)
    /// Big Small - 28
    public static let bigS: DSSpace = DSSpace(rawValue: 28)
    /// Normal - 24
    public static let normal: DSSpace = DSSpace(rawValue: 24)
    /// Small Large - 16
    public static let smallL: DSSpace = DSSpace(rawValue: 16)
    /// Small Medium - 8
    public static let smallM: DSSpace = DSSpace(rawValue: 8)
    /// Small Small - 4
    public static let smallS: DSSpace = DSSpace(rawValue: 4)
    /// Zero - 0
    public static let zero: DSSpace = DSSpace(rawValue: 0)
}

// MARK: - SwiftUI

public extension View {

    func padding(_ edges: Edge.Set = .all, space: DSSpace) -> some View {
        padding(edges, space.rawValue)
    }
}

public extension VStack {
    init(alignment: HorizontalAlignment = .center, spacing: DSSpace, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

public extension LazyVStack {
    init(alignment: HorizontalAlignment = .center, spacing: DSSpace, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, pinnedViews: pinnedViews, content: content)
    }
}

public extension HStack {
    init(alignment: VerticalAlignment = .center, spacing: DSSpace, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, content: content)
    }
}

public extension LazyHStack {
    init(alignment: VerticalAlignment = .center, spacing: DSSpace, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing.rawValue, pinnedViews: pinnedViews, content: content)
    }
}
