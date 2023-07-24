//
//  DashboardCreationView.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

public struct DashboardCreationView<ViewModel: DashboardCreationViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView(.vertical) {
            title
                .padding(.horizontal, space: .horizontal)

            Localizable.dashboardDescription.text
                .foregroundColor(DSColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)

            iconField
                .padding(.top, space: .smallS)

            nameField
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)

            entitiesList
                .padding(.top, space: .smallS)

            createButton
                .padding(.vertical, space: .normal)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var title: some View {
        HStack(alignment: .top, spacing: .smallL) {
            let title = viewModel.mode == .creation ? Localizable.dashboardCreation : Localizable.dashboardEdit

            title.text
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

    private var nameField: some View {
        VStack(spacing: .smallM) {
            Localizable.name.text
                .foregroundColor(DSColor.label)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: .smallS) {
                TextField("", text: $viewModel.dashboardName, axis: .horizontal)
                    .frame(height: 40)
                    .padding(.horizontal, space: .smallL)
                    .overlay(
                        RoundedRectangle(cornerRadius: .normal)
                            .stroke(DSColor.secondaryLabel)
                    )

                Localizable.nameHint.text
                    .foregroundColor(DSColor.secondaryLabel)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

        }
    }

    private var iconField: some View {
        VStack(spacing: .smallL) {
            Localizable.icon.text
                .foregroundColor(DSColor.label)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, space: .horizontal)

            IconsCarouselView(
                icons: viewModel.icons,
                selectedIconName: $viewModel.selectedIconName
            )

            VStack(spacing: .smallS) {
                VStack(spacing: .zero) {
                    TextField("", text: $viewModel.iconFilterText, axis: .horizontal)
                        .foregroundColor(DSColor.secondaryLabel)
                        .font(.subheadline)
                        .frame(height: 20)

                    Divider()
                }

                Localizable.iconHint.text
                    .foregroundColor(DSColor.secondaryLabel)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, space: .horizontal)
        }
    }

    private var entitiesList: some View {
        VStack(spacing: .smallL) {
            Localizable.entities.text
                .foregroundColor(DSColor.label)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, space: .horizontal)

            EntitiesListView(
                entities: viewModel.entities,
                entitySearchText: $viewModel.entityFilterText,
                selectedEntities: $viewModel.selectedEntitiesIDs,
                domains: viewModel.domains,
                selectedDomains: $viewModel.selectedDomainsNames
            )
        }
    }

    private var createButton: some View {
        Button(action: viewModel.createOrUpdateDashboard) {
            if viewModel.mode == .creation {
                Localizable.create.text
            } else {
                Localizable.update.text
            }
        }
        .buttonStyle(DefaultButtonStyle(
            foregroundColor: DSColor.background,
            backgroundColor: DSColor.label
        ))
    }
}

#if DEBUG
struct DashboardCreationView_Preview: PreviewProvider {

    static var previews: some View {

        DashboardCreationView(viewModel: DashboardCreationViewModelPreview())
    }
}
#endif
