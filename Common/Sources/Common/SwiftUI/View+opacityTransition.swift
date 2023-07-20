//
//  File.swift
//  
//
//  Created by Breno Aquino on 19/07/23.
//

import SwiftUI

public extension View {

    func opacityTransition() -> some View {
        transition(.opacity.animation(.linear(duration: 0.3)))
    }
}
