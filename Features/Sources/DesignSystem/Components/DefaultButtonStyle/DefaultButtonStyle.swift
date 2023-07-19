//
//  File.swift
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
