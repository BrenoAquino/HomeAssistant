//
//  EntitiesListView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Domain
import DesignSystem
import SwiftUI

struct EntitiesListView: View {

    let entities: [any Entity]
    @Binding var entitySearchText: String
    @Binding var selectedEntities: Set<String>
    let domains: [EntityDomain]
    @Binding var selectedDomains: Set<String>

    var body: some View {
        ScrollView(.vertical) {
            filters
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
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

        }
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
                TextField("", text: $entitySearchText, axis: .horizontal)
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

    @ViewBuilder private var entitiesList: some View {
        LazyVStack {
            ForEach(entities, id: \.id) { entity in
                Toggle(
                    isOn: .init(
                        get: { selectedEntities.contains(entity.id) },
                        set: { isSelected in
                            if isSelected {
                                selectedEntities.insert(entity.id)
                            } else {
                                selectedEntities.remove(entity.id)
                            }
                        }
                    )) {
                        HStack(spacing: .smallM) {
                            Image(systemName: entity.domain.icon)
                                .frame(width: 30)
                            Text(entity.name)
                        }
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .frame(height: 40)
            }
        }
    }
}

#if DEBUG
import Preview

struct EntitiesListView_Preview: PreviewProvider {

    static var entitySearchText: String = ""
    static var selectedEntities: Set<String> = []
    static var selectedDomains: Set<String> = []

    static var previews: some View {
        EntitiesListView(
            entities: EntityMock.all,
            entitySearchText: .init(get: { entitySearchText }, set: { entitySearchText = $0 }),
            selectedEntities: .init(get: { selectedEntities }, set: { selectedEntities = $0 }),
            domains: EntityDomain.allCases,
            selectedDomains: .init(get: { selectedDomains }, set: { selectedDomains = $0 })
        )
    }
}
#endif
