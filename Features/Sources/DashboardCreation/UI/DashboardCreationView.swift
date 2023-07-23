////
////  DashboardCreationView.swift
////  
////
////  Created by Breno Aquino on 18/07/23.
////
//
//import DesignSystem
//import SwiftUI
//
//public struct DashboardCreationView<ViewModel: DashboardCreationViewModel>: View {
//
//    @ObservedObject private var viewModel: ViewModel
//
//    public init(viewModel: ViewModel) {
//        self.viewModel = viewModel
//    }
//
//    public var body: some View {
//        ScrollView(.vertical) {
//            title
//                .padding(.horizontal, space: .normal)
//            
//            Localizable.dashboardDescription.text
//                .foregroundColor(SystemColor.secondaryLabel)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.callout)
//                .padding(.horizontal, space: .normal)
//                .padding(.top, space: .smallS)
//
//            iconField
//                .padding(.top, space: .smallS)
//
//            nameField
//                .padding(.horizontal, space: .normal)
//                .padding(.top, space: .smallS)
//
//            entitiesList
//                .padding(.top, space: .smallS)
//
//            createButton
//                .padding(.top, space: .normal)
//                .padding(.bottom, space: .normal)
//        }
//        .scrollDismissesKeyboard(.immediately)
//    }
//
//    private var title: some View {
//        HStack(alignment: .top, spacing: .smallL) {
//            let title = viewModel.mode == .creation ? Localizable.dashboardCreation : Localizable.dashboardEdit
//
//            title.text
//                .foregroundColor(SystemColor.label)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top, space: .bigL)
//
//            Button(action: viewModel.close) {
//                SystemImages.close
//                    .imageScale(.large)
//                    .foregroundColor(SystemColor.label)
//            }
//            .padding(.top, space: .normal)
//        }
//    }
//
//    private var nameField: some View {
//        VStack(spacing: .smallM) {
//            Localizable.name.text
//                .foregroundColor(SystemColor.label)
//                .font(.headline)
//                .fontWeight(.medium)
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            VStack(spacing: .smallS) {
//                TextField("", text: $viewModel.dashboardName, axis: .horizontal)
//                    .frame(height: 40)
//                    .padding(.horizontal, space: .smallL)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: .normal)
//                            .stroke(SystemColor.secondaryLabel)
//                    )
//
//                Localizable.nameHint.text
//                    .foregroundColor(SystemColor.secondaryLabel)
//                    .font(.footnote)
//                    .fontWeight(.medium)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//
//        }
//    }
//
//    private var iconField: some View {
//        VStack(spacing: .smallL) {
//            Localizable.icon.text
//                .foregroundColor(SystemColor.label)
//                .font(.headline)
//                .fontWeight(.medium)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, space: .normal)
//
//            IconsCarouselView(
//                icons: viewModel.icons,
//                selectedIcon: $viewModel.selectedIcon
//            )
//
//            VStack(spacing: .smallS) {
//                VStack(spacing: .zero) {
//                    TextField("", text: $viewModel.iconFilterText, axis: .horizontal)
//                        .foregroundColor(SystemColor.secondaryLabel)
//                        .font(.subheadline)
//                        .frame(height: 20)
//
//                    Divider()
//                }
//
//                Localizable.iconHint.text
//                    .foregroundColor(SystemColor.secondaryLabel)
//                    .font(.footnote)
//                    .fontWeight(.medium)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding(.horizontal, space: .normal)
//        }
//    }
//
//    private var entitiesList: some View {
//        VStack(spacing: .smallL) {
//            Localizable.entities.text
//                .foregroundColor(SystemColor.label)
//                .font(.headline)
//                .fontWeight(.medium)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, space: .normal)
//
//            EntitiesListView(
//                entities: viewModel.entities,
//                entitySearchText: $viewModel.entityFilterText,
//                selectedEntities: $viewModel.selectedEntitiesIDs,
//                domains: viewModel.domains,
//                selectedDomains: $viewModel.selectedDomainsNames
//            )
//        }
//    }
//
//    private var createButton: some View {
//        Button(action: viewModel.createOrUpdateDashboard) {
//            if viewModel.mode == .creation {
//                Localizable.create.text
//            } else {
//                Localizable.update.text
//            }
//        }
//        .buttonStyle(DefaultButtonStyle(
//            foregroundColor: SystemColor.background,
//            backgroundColor: SystemColor.label
//        ))
//    }
//}
//
//#if DEBUG
//import Preview
//
//struct DashboardCreationView_Preview: PreviewProvider {
//
//    static var previews: some View {
//
//        DashboardCreationView(
//            viewModel: .init(
//                dashboardService: DashboardServiceMock(),
//                entitiesService: EntityServiceMock(),
//                mode: .creation
//            )
//        )
//    }
//}
//#endif
