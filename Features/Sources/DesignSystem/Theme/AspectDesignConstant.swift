//
//  AspectDesignConstant.swift
//  
//
//  Created by Breno Aquino on 16/06/23.
//

import Foundation
import SwiftUI

public struct DSAspectRatio {
    public let rawValue: CGSize

    private init(rawValue: CGSize) {
        self.rawValue = rawValue
    }

    /// Portrait - Width (2) x Height (3)
    public static let portrait: DSAspectRatio = DSAspectRatio(rawValue: CGSize(width: 2, height: 3))
    /// Landscape - Width (2) x Height (3)
    public static let landscape: DSAspectRatio = DSAspectRatio(rawValue: CGSize(width: 16, height: 9))
}

// MARK: - General Proposal

public enum AspectDesignConstant {
    public static let portrait: CGSize = DSAspectRatio.portrait.rawValue
    public static let landscape: CGSize = DSAspectRatio.landscape.rawValue
}

// MARK: - Utils

public extension DSAspectRatio {
    var heightDividedByWidth: CGFloat { rawValue.height / rawValue.width }
    var widthDividedByHeight: CGFloat { rawValue.width / rawValue.height }
}

// MARK: - SwiftUI

public extension View {
    func aspectRatio(_ ratio: DSAspectRatio, contentMode: ContentMode) -> some View {
        aspectRatio(ratio.rawValue, contentMode: contentMode)
    }
}
