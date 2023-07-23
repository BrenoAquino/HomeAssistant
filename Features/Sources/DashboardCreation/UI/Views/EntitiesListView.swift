//
//  EntitiesListView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

struct EntitiesListView: View {

    let entities: [EntityUI]
    @Binding var entitySearchText: String
    @Binding var selectedEntities: Set<String>
    let domains: [any EntityDomainUI]
    @Binding var selectedDomains: Set<String>

    var body: some View {
        ScrollView(.vertical) {
            filters
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

            searchField
                .padding(.top, space: .smallL)
                .padding(.horizontal, space: .normal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

            entitiesList
                .padding(.top, space: .smallL)
                .padding(.horizontal, space: .normal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())

        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var filters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .smallM) {
                ForEach(domains, id: \.name) { domain in
                    domainElement(domain)
                }
            }
            .padding(.horizontal, space: .normal)
        }
    }

    @ViewBuilder private func domainElement(_ domain: EntityDomainUI) -> some View {
        let isSelected = selectedDomains.contains(domain.name)
        Text(domain.name)
            .padding(.vertical, space: .smallS)
            .padding(.horizontal, space: .smallL)
            .foregroundColor(isSelected ? DSColor.background : DSColor.label)
            .background(isSelected ? DSColor.label : DSColor.background)
            .overlay(Capsule().stroke(DSColor.label, lineWidth: 1))
            .clipShape(Capsule())
            .onTapGesture {
                if isSelected {
                    selectedDomains.remove(domain.name)
                } else {
                    selectedDomains.insert(domain.name)
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
                            Image(systemName: entity.domainUI.icon)
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
import Domain

struct EntitiesListView_Preview: PreviewProvider {

    private struct DomainMock: EntityDomainUI {
        let name: String
        let icon: String
    }

    static var entitySearchText: String = ""
    static var selectedEntities: Set<String> = []
    static var selectedDomains: Set<String> = []

    static var previews: some View {
        let lightDomain = DomainMock(name: "light", icon: "lightbulb.led")
        let switchDomain = DomainMock(name: "switch", icon: "lightswitch.on")
        let fanDomain = DomainMock(name: "fan", icon: "fan.desk")
        let climateDomain = DomainMock(name: "climate", icon: "air.conditioner.horizontal")
        let mainLight = EntityUI(id: "1", name: "Main Light", domainUI: lightDomain)
        let ledDesk = EntityUI(id: "2", name: "Led Desk", domainUI: lightDomain)
        let ledCeiling = EntityUI(id: "3", name: "Led Ceiling", domainUI: lightDomain)
        let climate = EntityUI(id: "4", name: "Air Conditioner", domainUI: climateDomain)
        let coffeeMachine = EntityUI(id: "5", name: "Coffee Machine", domainUI: switchDomain)
        let fan = EntityUI(id: "6", name: "Bedroom's Fan", domainUI: fanDomain)

        EntitiesListView(
            entities: [mainLight, ledDesk, ledCeiling, climate, coffeeMachine, fan],
            entitySearchText: .init(get: { entitySearchText }, set: { entitySearchText = $0 }),
            selectedEntities: .init(get: { selectedEntities }, set: { selectedEntities = $0 }),
            domains: [lightDomain, switchDomain, fanDomain, climateDomain],
            selectedDomains: .init(get: { selectedDomains }, set: { selectedDomains = $0 })
        )
    }
}
#endif
