//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

public extension View {

    @ViewBuilder
    func overlayIfNotNil<Overlay: View>(_ element: Overlay?, alignment: Alignment = .center) -> some View {
        if let element {
            overlay(element, alignment: alignment)
        } else {
            self
        }
    }

    @ViewBuilder
    func overlay<Overlay: View>(_ element: Overlay, alignment: Alignment = .center, isPresent: Bool) -> some View {
        if isPresent {
            overlay(element, alignment: alignment)
        } else {
            self
        }
    }
}
