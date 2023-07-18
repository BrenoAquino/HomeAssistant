//
//  RoomsView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import SwiftUI

struct RoomsView: View {

    var rooms: [RoomUI]
    var selectedRoom: Int

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: .smallL) {
                ForEach(Array(rooms.enumerated()), id: \.element.id) { (offset, roomUI) in
                    squareElement(roomUI.name, roomUI.icon, offset)
                }
                squareElement("", "plus.circle", rooms.count + 1)
            }
            .padding(.horizontal, space: .smallL)
        }
    }

    @ViewBuilder func squareElement(
        _ title: String,
        _ icon: String,
        _ offset: Int
    ) -> some View {
        let isSelected = offset == selectedRoom

        VStack(spacing: .smallM) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? SystemColor.background : SystemColor.label)
                .frame(width: 80, height: 80)
                .background(isSelected ? SystemColor.label : SystemColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: .hard)
                        .stroke(
                            isSelected ? SystemColor.background : SystemColor.gray3,
                            lineWidth: 1
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: .hard))


            Text(title)
                .font(.subheadline)
        }
    }
}

#if DEBUG
struct RoomsView_Preview: PreviewProvider {

    static var previews: some View {
        RoomsView(
            rooms: [
                .init(name: "Quarto", icon: "bed.double"),
                .init(name: "Sala", icon: "sofa"),
                .init(name: "Cozinha", icon: "refrigerator"),
                .init(name: "Jardim", icon: "tree"),
            ],
            selectedRoom: 0
        )
    }
}
#endif
