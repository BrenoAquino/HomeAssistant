//
//  CheckboxToggleStyle.swift
//  
//
//  Created by Breno Aquino on 22/07/23.
//

import SwiftUI

public struct CheckboxToggleStyle: ToggleStyle {

    private enum Constants {
        static let iconSize: CGFloat = 22
        static let animationDuration: TimeInterval = 0.1
        static let onIconName = "checkmark.circle"
        static let offIconName = "circle"
    }

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            let image = configuration.isOn ? SystemImages.check : SystemImages.uncheck
            configuration.label
            Spacer()
            image
                .resizable()
                .frame(width: Constants.iconSize, height: Constants.iconSize)
                .animation(.easeInOut(duration: Constants.animationDuration), value: configuration.isOn)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            configuration.isOn.toggle()
        }
    }
}
