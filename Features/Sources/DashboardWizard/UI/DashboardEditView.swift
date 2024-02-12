//
//  DashboardEditView.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

private enum Constants {
    static let inputNameHeight: CGFloat = 40
    static let inputIconSearchHeight: CGFloat = 20
}

public struct DashboardWizardView<ViewModel: DashboardWizardViewModel>: View {
    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Localizable.dashboardDescription.text
                    .foregroundColor(DSColor.secondaryLabel)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.callout)
                    .padding(.horizontal, space: .horizontal)

                nameField
                    .padding(.top, space: .smallS)
                    .padding(.horizontal, space: .horizontal)

                columnsNumber
                    .padding(.top, space: .smallM)
                    .padding(.horizontal, space: .horizontal)

                iconField(proxy)
                    .padding(.top, space: .smallS)

                Spacer()
                    .padding(.top, space: .bigL)
            }
            .overlay(createButton, alignment: .bottom)
        }
        .background(DSColor.background)
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle(
            viewModel.mode == .creation ? Localizable.dashboardCreation.value : Localizable.dashboardEdit.value
        )
        .toolbar {
            closeButton
        }
        .toast(data: $viewModel.toastData)
    }

    private var closeButton: some View {
        Button(action: viewModel.close) {
            SystemImages.close
                .imageScale(.large)
                .foregroundColor(DSColor.label)
        }
        .foregroundColor(DSColor.label)
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
                    .frame(height: Constants.inputNameHeight)
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

    private var columnsNumber: some View {
        VStack(spacing: .smallM) {
            HStack(spacing: .zero) {
                Localizable.columns.text
                    .foregroundColor(DSColor.label)
                    .font(.headline)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)

                StepperWithNumber(number: .init(
                    get: { Double(viewModel.columnsNumber) },
                    set: { viewModel.columnsNumber = Int($0) }
                ))
            }

            Localizable.columnsDescription.text
                .foregroundColor(DSColor.secondaryLabel)
                .font(.footnote)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func iconField(
        _ proxy: GeometryProxy
    ) -> some View {
        VStack(spacing: .smallL) {
            Localizable.icon.text
                .foregroundColor(DSColor.label)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, space: .horizontal)

            VStack(spacing: .smallS) {
                VStack(spacing: .zero) {
                    TextField(
                        Localizable.iconExample.value,
                        text: $viewModel.iconFilterText,
                        axis: .horizontal
                    )
                    .foregroundColor(DSColor.secondaryLabel)
                    .font(.subheadline)
                    .frame(height: Constants.inputIconSearchHeight)

                    Divider()
                }

                Localizable.iconHint.text
                    .foregroundColor(DSColor.secondaryLabel)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, space: .horizontal)

            IconsListView(
                proxy: proxy,
                icons: viewModel.icons,
                selectedIconName: $viewModel.selectedIconName
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
        .shadow(radius: .normal)
    }
}

#if DEBUG
struct DashboardWizardView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardWizardView(viewModel: DashboardWizardViewModelPreview())
        }
    }
}
#endif
