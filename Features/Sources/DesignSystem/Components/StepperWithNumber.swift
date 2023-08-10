//
//  File.swift
//  
//
//  Created by Breno Aquino on 08/08/23.
//

import SwiftUI

private enum Constants {

    static let elementWidth: CGFloat = 30
}

public struct StepperWithNumber: View {

    @Binding private var number: Double
    private let stepValue: Double
    private let maxValue: Double
    private let minValue: Double
    private let formatter: (_ number: Double) -> String

    public init(
        number: Binding<Double>,
        stepValue: Double = 1,
        maxValue: Double = .infinity,
        minValue: Double = .zero,
        formatter: @escaping (_ number: Double) -> String = { String(Int($0)) }
    ) {
        self._number = number
        self.stepValue = stepValue
        self.maxValue = maxValue
        self.minValue = minValue
        self.formatter = formatter
    }

    public var body: some View {
        HStack(spacing: .zero) {
            Button(action: {
                number = max(number - 1, minValue)
            }) {
                Image(systemName: "minus")
                    .foregroundColor(DSColor.label)
            }
            .padding(.horizontal, space: .smallS)
            .frame(width: Constants.elementWidth)
            .frame(maxHeight: .infinity)

            HStack {
                Divider()
                Text(formatter(number))
                    .frame(width: Constants.elementWidth)
                    .foregroundColor(DSColor.label)
                Divider()
            }

            Button(action: {
                number = min(number + 1, maxValue)
            }) {
                Image(systemName: "plus")
                    .foregroundColor(DSColor.label)
            }
            .padding(.horizontal, space: .smallS)
            .frame(width: Constants.elementWidth)
            .frame(maxHeight: .infinity)
        }
        .padding(.vertical, space: .smallS)
        .padding(.horizontal, space: .smallS)
        .background(Material.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: .normal))
    }
}

#if DEBUG
struct StepperWithNumber_Preview: PreviewProvider {

    static var previews: some View {
        StepperWithNumber(number: .constant(20))
    }
}
#endif
