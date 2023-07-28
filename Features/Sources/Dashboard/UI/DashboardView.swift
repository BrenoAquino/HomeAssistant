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
                selectedDashboardName: $viewModel.selectedDashboardName,
                didUpdateOrder: viewModel.didUpdateDashboardsOrder,
                didClickRemoveDashboard: viewModel.didClickRemove,
                didClickEditDashboard: viewModel.didClickEdit,
                didClickAdd: viewModel.didClickAddDashboard
            )
            .padding(.top, space: .smallS)
            
            Localizable.devices.text
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, space: .smallS)
                .padding(.horizontal, space: .horizontal)
            
            EntitiesView(
                editMode: $viewModel.editModel,
                entities: $viewModel.entities,
                didUpdateOrder: viewModel.didUpdateEntitiesOrder,
                didClickRemoveEntity: viewModel.didClickRemove,
                didClickUpdateLightState: viewModel.didClickUpdateLightState,
                didClickUpdateFanState: viewModel.didClickUpdateFanState
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
        .alert(Localizable.delete.value, isPresented: $viewModel.removeDashboardAlert, actions: {
            Button(Localizable.cancel.value, role: .cancel, action: viewModel.cancelDashboardDeletion)
            Button(Localizable.ok.value, role: .destructive, action: viewModel.deleteRequestedDashboard)
        }, message: {
            Localizable.deleteDashboardDescription.text
        })
        .alert(Localizable.delete.value, isPresented: $viewModel.removeEntityAlert, actions: {
            Button(Localizable.cancel.value, role: .cancel, action: viewModel.cancelEntityDeletion)
            Button(Localizable.ok.value, role: .destructive, action: viewModel.deleteRequestedEntity)
        }, message: {
            Localizable.deleteEntityDescription.text
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
