//
//  ConfigView.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import DesignSystem
import SwiftUI

public struct ConfigView<ViewModel: ConfigViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            title
                .padding(.horizontal, space: .horizontal)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            searchField
                .padding(.top, space: .normal)
                .padding(.horizontal, space: .horizontal)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(viewModel.entities, id: \.id) { entity in
                entityCell(entity)
                    .padding(.horizontal, space: .horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }
            .padding(.top, space: .smallS)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }

    private var title: some View {
        HStack(alignment: .top, spacing: .smallL) {
            Localizable.config.text
                .foregroundColor(DSColor.label)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, space: .bigL)

            Button(action: viewModel.close) {
                SystemImages.close
                    .imageScale(.large)
                    .foregroundColor(DSColor.label)
            }
            .padding(.top, space: .normal)
        }
    }

    private var searchField: some View {
        VStack(spacing: .smallS) {
            VStack(spacing: .zero) {
                TextField("", text: $viewModel.entityFilterText, axis: .horizontal)
                    .foregroundColor(DSColor.secondaryLabel)
                    .font(.subheadline)
                    .frame(height: 20)

                Divider()
            }

            Localizable.entitiesHint.text
                .foregroundColor(DSColor.secondaryLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private func entityCell(_ entity: any Entity) -> some View {
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
        .contentShape(Rectangle())
        .onTapGesture {
            if isHidden {
                viewModel.hiddenEntityIDs.remove(entity.id)
            } else {
                viewModel.hiddenEntityIDs.insert(entity.id)
            }
        }
    }
}

#if DEBUG
struct ConfigView_Preview: PreviewProvider {

    static var previews: some View {
        
        ConfigView(viewModel: ConfigViewModelPreview())
    }
}
#endif
