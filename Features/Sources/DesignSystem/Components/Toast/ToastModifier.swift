//
//  ToastModifier.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var showToast: Bool
    let config: ToastConfig

    func body(content: Content) -> some View {
        content
            .toastConfig(config)
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
    }
}

private extension View {

    func toastConfig(_ config: ToastConfig) -> some View {
        switch config.transition {
        case .fade:
            return transition(.opacity.animation(config.animation))
        case .scale:
            return transition(.scale.animation(config.animation))
        case .slide:
            switch config.alignment {
            case .top:
                return transition(.move(edge: .top).combined(with: .opacity).animation(config.animation))
            case .bottom:
                return transition(.move(edge: .bottom).combined(with: .opacity).animation(config.animation))
            }
        }
    }
}
