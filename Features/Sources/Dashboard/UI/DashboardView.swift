//
//  DashboardView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Common
import DesignSystem
import SwiftUI

public struct DashboardView<ViewModel: DashboardViewModel>: View {
    @ObservedObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            Localizable.welcome.text
                .foregroundColor(DSColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)

            DashboardsCarouselView(
                dashboards: viewModel.dashboards,
                selectedDashboardName: $viewModel.selectedDashboardName,
                didClickAdd: viewModel.didClickAddDashboard
            )
            .padding(.top, space: .smallS)
            
            deviceSection
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)

            WidgetsGridView(
                widgets: viewModel.widgets,
                didClickUpdateLightState: viewModel.didClickUpdateLightState,
                didClickUpdateFanState: viewModel.didClickUpdateFanState
            )
            .padding(.top, space: .smallS)
        }
        .background(DSColor.background)
        .navigationTitle(Localizable.hiThere.value)
        .toolbar {
            Group {
                editButton
                configButton
            }
            .foregroundColor(DSColor.label)
        }
        .toast(data: $viewModel.toastData)
    }

    private var configButton: some View {
        Button {
            viewModel.didClickConfig()
        } label: {
            SystemImages.config
        }
    }

    private var editButton: some View {
        Button {
            viewModel.didClickEdit()
        } label: {
            SystemImages.edit
        }
    }

    private var deviceSection: some View {
        HStack(spacing: .smallM) {
            Localizable.devices.text
                .font(.title3)
                .fontWeight(.semibold)
                .frame(alignment: .leading)

            Spacer()

            Button(action: viewModel.didClickAddWidget) {
                SystemImages.plus
                    .foregroundColor(DSColor.label)
            }
        }
    }
}

#if DEBUG
struct DashboardView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView(viewModel: DashboardViewModelPreview())
        }
    }
}
#endif
