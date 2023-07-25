//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

public struct ToastConfig {

    public enum Transition {
        case fade, slide, scale
    }

    public enum Alignment {
        case top, bottom
    }

    public let hideAfter: TimeInterval?
    public let dismissOnTap: Bool
    public let alignment: Alignment
    public let animation: Animation
    public let transition: Transition

    public init(
        hideAfter: TimeInterval? = 3,
        dismissOnTap: Bool = true,
        alignment: Alignment = .top,
        animation: Animation = .easeInOut,
        transition: Transition = .slide
    ) {
        self.hideAfter = hideAfter
        self.dismissOnTap = dismissOnTap
        self.alignment = alignment
        self.animation = animation
        self.transition = transition
    }
}

extension ToastConfig.Alignment {
    var alignement: SwiftUI.Alignment {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

public extension ToastConfig {
    static let `default`: ToastConfig = .init()
}
