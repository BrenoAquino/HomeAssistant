//
//  View+opacityTransition.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

extension View {

    func opacityTransition() -> some View {
        transition(.opacity.animation(.linear(duration: 0.3)))
    }
}
