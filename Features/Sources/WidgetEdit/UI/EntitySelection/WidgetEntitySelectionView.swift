//
//  WidgetEntitySelectionView.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import DesignSystem
import Domain
import SwiftUI

private enum Constants {

    static let iconSize: CGFloat = 30
    static let searchHeight: CGFloat = 20
}

struct WidgetEntitySelectionView<ViewModel: EntitySelectionViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Localizable.entitySelectionDescription.text
                .foregroundColor(DSColor.secondaryLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .padding(.horizontal, space: .horizontal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

            filters
                .padding(.top, space: .smallL)
                .padding(.vertical, space: .smallS)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

            searchField
                .padding(.top, space: .smallL)
                .padding(.horizontal, space: .horizontal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

            entitiesList
                .padding(.top, space: .smallL)
                .padding(.horizontal, space: .horizontal)
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle(Localizable.entitySelectionTitle.value)
        .toolbar {
            closeButton
        }
    }

    private var closeButton: some View {
        Button(action: viewModel.close) {
            SystemImages.close
                .imageScale(.large)
                .foregroundColor(DSColor.label)
        }
        .foregroundColor(DSColor.label)
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallM) {
                ForEach(viewModel.domains, id: \.rawValue) { domain in
                    domainElement(domain)
                }
            }
            .padding(.horizontal, space: .horizontal)
        }
    }

    @ViewBuilder private func domainElement(_ domain: EntityDomain) -> some View {
        let isSelected = viewModel.selectedDomainsNames.contains(domain.rawValue)
        Text(domain.rawValue)
            .padding(.vertical, space: .smallS)
            .padding(.horizontal, space: .horizontal)
            .foregroundColor(isSelected ? DSColor.background : DSColor.label)
            .background(isSelected ? DSColor.label : DSColor.background)
            .overlay(Capsule().stroke(DSColor.label, lineWidth: 1))
            .clipShape(Capsule())
            .onTapGesture {
                if isSelected {
                    viewModel.selectedDomainsNames.remove(domain.rawValue)
                } else {
                    viewModel.selectedDomainsNames.insert(domain.rawValue)
                }
            }
    }

    private var searchField: some View {
        VStack(spacing: .smallS) {
            VStack(spacing: .zero) {
                TextField(
                    Localizable.entitiesSearchExample.value,
                    text: $viewModel.entityFilterText,
                    axis: .horizontal
                )
                .foregroundColor(DSColor.secondaryLabel)
                .font(.subheadline)
                .frame(height: Constants.searchHeight)

                Divider()
            }

            Localizable.entitiesHint.text
                .foregroundColor(DSColor.secondaryLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var entitiesList: some View {
        ForEach(viewModel.entities, id: \.entity.id) { anyEntity in
            NavigationLink(value: anyEntity) {
                HStack(spacing: .smallM) {
                    Image(systemName: anyEntity.entity.domain.icon)
                        .frame(width: Constants.iconSize)

                    Text(anyEntity.entity.name)
                        .foregroundColor(DSColor.label)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.top, space: .smallM)
            .padding(.bottom, space: .smallM)
            .listRowInsets(EdgeInsets())
            .contentShape(Rectangle())
        }
    }
}

#if DEBUG
import Preview

struct WidgetEntitySelectionView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            WidgetEntitySelectionView(viewModel: EntitySelectionViewModelPreview())
        }
    }
}
#endif
