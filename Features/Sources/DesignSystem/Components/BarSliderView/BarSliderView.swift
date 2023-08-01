//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI

public struct BarSliderView: View {

    @Binding private var percentage: Double
    private let backgroundColor: Color
    private let foregroundColor: Color

    public init(percentage: Binding<Double>, backgroundColor: Color, foregroundColor: Color) {
        self._percentage = percentage
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(backgroundColor)

                Rectangle()
                    .foregroundColor(foregroundColor)
                    .frame(width: proxy.size.width * percentage, alignment: .leading)
            }
            .clipShape(Capsule())
            .gesture(
                DragGesture(minimumDistance: .zero)
                    .onChanged { value in
                        percentage = max(value.location.x / proxy.size.width, .zero)
                    }
            )
        }
    }
}

#if DEBUG
struct BarSliderView_Preview: PreviewProvider {

    static var previews: some View {

        BarSliderView(
            percentage: .constant(0.25),
            backgroundColor: .gray,
            foregroundColor: .black
        )
            .padding(.horizontal)
            .frame(height: 100)
    }
}
#endif
