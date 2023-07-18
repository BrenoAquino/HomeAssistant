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
                    roomElement(roomUI, offset)
                }
            }
            .padding(.horizontal, space: .smallL)
        }
    }

    @ViewBuilder func roomElement(_ roomUI: RoomUI, _ offset: Int) -> some View {
        let isSelected = offset == selectedRoom

        VStack(spacing: .smallM) {
            Image(systemName: roomUI.icon)
                .foregroundColor(color: isSelected ? .background : .primaryText)
                .frame(width: 80, height: 80)
                .background(color: isSelected ? .primaryText : .background)
                .overlay(
                    RoundedRectangle(cornerRadius: .hard)
                        .stroke(.primaryText, lineWidth: 1)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: .hard)
//                        .stroke(Color.purple, lineWidth: 4)
                )


            Text(roomUI.name)
                .font(.subheadline)
        }
    }
}

#if DEBUG
struct RoomsView_Preview: PreviewProvider {

    static var previews: some View {
        RoomsView(
            rooms: [
                .init(name: "Quarto Breno", icon: "bed.double.fill"),
                .init(name: "Jardim", icon: "tree.fill"),
            ],
            selectedRoom: 0
        )
    }
}
#endif
