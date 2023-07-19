//
//  EntitiesListView.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

struct EntitiesListView: View {

    let entities: [any EntityUI]
    let selectedEntities: Set<String>
    @Binding var entitySearchText: String
    let didChangeEntitySelection: ((
        _ entity: EntityUI,
        _ isSelected: Bool
    ) -> Void
    )?
    let domains: [any EntityDomainUI]
    let selectedDomains: Set<String>
    let didChangeDomainSelection: ((
        _ domain: EntityDomainUI,
        _ isSelected: Bool
    ) -> Void
    )?

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
            .foregroundColor(isSelected ? SystemColor.background : SystemColor.label)
            .background(isSelected ? SystemColor.label : SystemColor.background)
            .overlay(Capsule().stroke(SystemColor.label, lineWidth: 1))
            .clipShape(Capsule())
            .onTapGesture {
                didChangeDomainSelection?(domain, !isSelected)
            }
    }

    private var searchField: some View {
        VStack(spacing: .smallS) {
            VStack(spacing: .zero) {
                TextField("", text: $entitySearchText, axis: .horizontal)
                    .foregroundColor(SystemColor.secondaryLabel)
                    .font(.subheadline)
                    .frame(height: 20)

                Divider()
            }

            Localizable.entitiesHint.text
                .foregroundColor(SystemColor.secondaryLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder private var entitiesList: some View {
        LazyVStack {
            ForEach(entities, id: \.id) { entity in
                let isSelected = selectedEntities.contains(entity.id)
                let image = isSelected ? SystemImages.check : SystemImages.uncheck

                HStack(spacing: .smallM) {
                    image.imageScale(.large)
                    Text(entity.name)
                    Spacer()
                    Image(systemName: entity.domainUI.icon)
                }
                .frame(height: 40)
                .background(Color.clear)
                .onTapGesture {
                    didChangeEntitySelection?(entity, !isSelected)
                }
            }
        }
    }
}

#if DEBUG
struct EntitiesListView_Preview: PreviewProvider {

    private struct DomainMock: EntityDomainUI {
        let name: String
        let icon: String
    }

    private struct EntityMock: EntityUI {
        let id: String = UUID().uuidString
        let name: String
        var domainUI: EntityDomainUI
    }

    static var previews: some View {
        let lightDomain = DomainMock(name: "light", icon: "lightbulb.led")
        let switchDomain = DomainMock(name: "switch", icon: "lightswitch.on")
        let fanDomain = DomainMock(name: "fan", icon: "fan.desk")
        let climateDomain = DomainMock(name: "climate", icon: "air.conditioner.horizontal")
        let mainLight = EntityMock(name: "Main Light", domainUI: lightDomain)
        let ledDesk = EntityMock(name: "Led Desk", domainUI: lightDomain)
        let ledCeiling = EntityMock(name: "Led Ceiling", domainUI: lightDomain)
        let climate = EntityMock(name: "Air Conditioner", domainUI: climateDomain)
        let coffeeMachine = EntityMock(name: "Coffee Machine", domainUI: switchDomain)
        let fan = EntityMock(name: "Bedroom's Fan", domainUI: fanDomain)

        EntitiesListView(
            entities: [mainLight, ledDesk, ledCeiling, climate, coffeeMachine, fan],
            selectedEntities: [],
            entitySearchText: .constant(""),
            didChangeEntitySelection: { _, _ in },
            domains: [lightDomain, switchDomain, fanDomain, climateDomain],
            selectedDomains: [],
            didChangeDomainSelection: { _, _ in}
        )
    }
}
#endif
