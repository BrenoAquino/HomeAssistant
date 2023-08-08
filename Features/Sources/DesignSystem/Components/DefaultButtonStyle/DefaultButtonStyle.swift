//
//  DefaultButtonStyle.swift
//  
//
//  Created by Breno Aquino on 19/07/23.
//

import SwiftUI

public struct DefaultButtonStyle: ButtonStyle {

    private let foregroundColor: Color
    private let backgroundColor: Color

    public init(
        foregroundColor: Color,
        backgroundColor: Color
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, space: .smallM)
            .padding(.horizontal, space: .normal)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

public struct DefaultMaterialButtonStyle: ButtonStyle {

    private let foregroundColor: Color
    private let material: Material

    public init(
        foregroundColor: Color,
        material: Material
    ) {
        self.foregroundColor = foregroundColor
        self.material = material
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.vertical, space: .smallM)
            .padding(.horizontal, space: .normal)
            .foregroundColor(foregroundColor)
            .background(material)
            .cornerRadius(8)
    }
}
