//
//  File.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import DesignSystem
import SwiftUI

struct UnsupportedView: View {

    let name: String
    let domain: String

    var body: some View {
        VStack {
            Text(name)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .foregroundColor(SystemColor.label)
                .font(.headline)

            Localizable.unsupported.text
                .textCase(.uppercase)
                .scaledToFill()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .foregroundColor(SystemColor.tertiaryLabel)
                .font(.subheadline)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding(.vertical, space: .smallL)
        .padding(.horizontal, space: .smallL)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(SystemColor.gray5)
        .overlay(
            RoundedRectangle(cornerRadius: .hard)
                .stroke(SystemColor.gray4, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: .hard))
        .contentShape(Rectangle())
    }
}

#if DEBUG
struct UnsupportedView_Preview: PreviewProvider {

    static var previews: some View {
        let size: CGFloat = 150
        
        UnsupportedView(name: "Breno's Fan", domain: "fan")
            .frame(width: size, height: size)
    }
}
#endif
