//
//  FanWidgetView.swift
//  
//
//  Created by Breno Aquino on 27/07/23.
//

import Domain
import SwiftUI

private enum Constants {

    static let shadowOpacity: CGFloat = 0.2
    static let strokeWidth: CGFloat = 1
    static let strokeOpacity: CGFloat = 0.5
}

public struct FanWidgetView: WidgetView {

    public static let uniqueID: String = "default"
    public static let units: (columns: Int, rows: Int) = (1, 1)

    let fanEntity: FanEntity
    let updateState: (_ fanEntity: FanEntity, _ newState: FanEntity.State) -> Void

    @State private var isRotating = 0.0

    public init(
        fanEntity: FanEntity,
        updateState: @escaping (_ entity: FanEntity, _ newState: FanEntity.State) -> Void
    ) {
        self.fanEntity = fanEntity
        self.updateState = updateState
        self.isRotating = isRotating
    }

    public var body: some View {
        content
            .padding(.vertical, space: .smallL)
            .padding(.horizontal, space: .smallL)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(fanEntity.isOn ? DSColor.activated : DSColor.deactivated)
            )
            .clipShape(
                RoundedRectangle(cornerRadius: .hard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .hard)
                    .stroke(DSColor.gray3.opacity(Constants.strokeOpacity), lineWidth: Constants.strokeWidth)
            )
            .contentShape(Rectangle())
            .shadow(radius: .easy, color: .black.opacity(Constants.shadowOpacity))
            .onTapGesture {
                updateState(fanEntity, fanEntity.invertedState)
            }
            .onChange(of: fanEntity.isOn) { newValue in
                withAnimation(.linear.speed(0.1).repeatForever(autoreverses: false)) {
                    isRotating = -360
                }
            }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: .zero) {
            ZStack {
                Image(systemName: fanEntity.offIcon)
                    .foregroundColor(.white)
                    .padding(.all, space: .smallL)
                    .background(DSColor.gray)
                    .clipShape(Circle())
                    .opacity(!fanEntity.isOn ? 1 : 0)

                Image(systemName: fanEntity.onIcon)
                    .foregroundColor(.white)
                    .padding(.all, space: .smallL)
                    .rotationEffect(.degrees(isRotating))
                    .background(DSColor.orange)
                    .clipShape(Circle())
                    .opacity(fanEntity.isOn ? 1 : 0)
            }

            Text(fanEntity.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(fanEntity.isOn ? .black : DSColor.label)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
}

#if DEBUG
import Preview

struct FanWidgetView_Preview: PreviewProvider {

    private static var entityOn = FanEntity(id: "1", name: "Breno's Fan", percentageStep: nil, percentage: nil, state: .on)
    private static var entityOff = FanEntity(id: "2", name: "Couple's Fan", percentageStep: 20, percentage: 40, state: .off)

    static var previews: some View {
        let size: CGFloat = 150

        HStack(spacing: .bigL) {
            FanWidgetView(
                fanEntity: entityOn,
                updateState: { _, _ in }
            )
            .frame(width: size, height: size)

            FanWidgetView(
                fanEntity: entityOff,
                updateState: { _, _ in }
            )
            .frame(width: size, height: size)
        }
    }
}
#endif
