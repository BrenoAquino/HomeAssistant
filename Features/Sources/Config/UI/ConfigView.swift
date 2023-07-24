//
//  ConfigView.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import DesignSystem
import SwiftUI

public struct ConfigView<ViewModel: ConfigViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List(viewModel.entities, id: \.id) { entity in
            let isHidden = viewModel.hiddenEntityIDs.contains(entity.id)
            let image = isHidden ? SystemImages.hidden : SystemImages.visible

            HStack {
                HStack(spacing: .smallM) {
                    Image(systemName: entity.domain.icon)
                        .foregroundColor(isHidden ? DSColor.secondaryLabel : DSColor.label)
                        .frame(width: 30)

                    Text(entity.name)
                        .strikethrough(isHidden)
                        .foregroundColor(isHidden ? DSColor.secondaryLabel : DSColor.label)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                image
                    .resizable()
                    .foregroundColor(isHidden ? DSColor.secondaryLabel : DSColor.label)
                    .fixedSize()
                    .scaledToFit()
            }
            .frame(height: 40)
            .onTapGesture {
                if isHidden {
                    viewModel.hiddenEntityIDs.remove(entity.id)
                } else {
                    viewModel.hiddenEntityIDs.insert(entity.id)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#if DEBUG
struct ConfigView_Preview: PreviewProvider {

    static var previews: some View {
        
        ConfigView(viewModel: ConfigViewModelPreview())
    }
}
#endif
