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
                editMode: $viewModel.editModel,
                dashboards: $viewModel.dashboards,
                selectedDashboardIndex: $viewModel.selectedDashboardIndex,
                dashboardDidRemove: viewModel.didClickRemove,
                dashboardDidEdit: viewModel.didClickEdit,
                addDidSelect: viewModel.didClickAdd
            )
            .padding(.top, space: .smallS)
            
            Localizable.devices.text
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)
            
            EntitiesView(
                entities: viewModel.entities,
                didClickUpdateLightState: viewModel.didClickUpdateLightState
            )
            .padding(.top, space: .smallS)
        }
        .background(DSColor.background)
        .navigationTitle(Localizable.hiThere.value)
        .toolbar {
            Group {
                if viewModel.editModel {
                    doneButton
                } else {
                    configButton
                }
            }
            .foregroundColor(DSColor.label)
        }
        .toast(data: $viewModel.toastData)
        .alert(Localizable.delete.value, isPresented: $viewModel.removeAlert, actions: {
            Button(Localizable.cancel.value, role: .cancel, action: viewModel.cancelDashboardDeletion)
            Button(Localizable.ok.value, role: .destructive, action: viewModel.deleteRequestedDashboard)
        }, message: {
            Localizable.deleteDescription.text
        })
    }
    
    private var doneButton: some View {
        Button {
            viewModel.editModel = false
        } label: {
            Localizable.done.text
        }
    }

    private var configButton: some View {
        Button {
            viewModel.didClickConfig()
        } label: {
            SystemImages.config
        }
    }
}

#if DEBUG
struct DashboardView_Preview: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: DashboardViewModelPreview())
        }
    }
}
#endif
