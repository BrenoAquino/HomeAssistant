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

struct WidgetEntitySelectionView: View {

    let entities: [any Entity]
    @Binding var entitySearchText: String
    let domains: [EntityDomain]
    @Binding var selectedDomains: Set<String>
    let didSelectEntity: (_ entity: any Entity) -> Void

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
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallM) {
                ForEach(domains, id: \.rawValue) { domain in
                    domainElement(domain)
                }
            }
            .padding(.horizontal, space: .horizontal)
        }
    }

    @ViewBuilder private func domainElement(_ domain: EntityDomain) -> some View {
        let isSelected = selectedDomains.contains(domain.rawValue)
        Text(domain.rawValue)
            .padding(.vertical, space: .smallS)
            .padding(.horizontal, space: .horizontal)
            .foregroundColor(isSelected ? DSColor.background : DSColor.label)
            .background(isSelected ? DSColor.label : DSColor.background)
            .overlay(Capsule().stroke(DSColor.label, lineWidth: 1))
            .clipShape(Capsule())
            .onTapGesture {
                if isSelected {
                    selectedDomains.remove(domain.rawValue)
                } else {
                    selectedDomains.insert(domain.rawValue)
                }
            }
    }

    private var searchField: some View {
        VStack(spacing: .smallS) {
            VStack(spacing: .zero) {
                TextField(
                    Localizable.entitiesSearchExample.value,
                    text: $entitySearchText,
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
        ForEach(entities, id: \.id) { entity in
            HStack(spacing: .smallM) {
                Image(systemName: entity.domain.icon)
                    .frame(width: Constants.iconSize)

                Text(entity.name)
                    .foregroundColor(DSColor.label)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)

                SystemImages.rightArrow
                    .frame(width: Constants.iconSize)
            }
            .padding(.top, space: .smallM)
            .padding(.bottom, space: .smallM)
            .listRowInsets(EdgeInsets())
            .contentShape(Rectangle())
            .onTapGesture {
                didSelectEntity(entity)
            }
        }
    }
}

#if DEBUG
import Preview

struct WidgetEntitySelectionView_Preview: PreviewProvider {

    static var entitySearchText: String = ""
    static var selectedEntities: Set<String> = []
    static var selectedDomains: Set<String> = []

    static var previews: some View {
        WidgetEntitySelectionView(
            entities: EntityMock.all,
            entitySearchText: .init(get: { entitySearchText }, set: { entitySearchText = $0 }),
            domains: EntityDomain.allCases,
            selectedDomains: .init(get: { selectedDomains }, set: { selectedDomains = $0 }),
            didSelectEntity: { _ in }
        )
    }
}
#endif
