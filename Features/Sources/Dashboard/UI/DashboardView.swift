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

public struct DashboardView: View {

    @ObservedObject private var viewModel: DashboardViewModel

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView(.vertical) {
//            Localizable.welcome.text
//                .foregroundColor(SystemColor.secondaryLabel)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.callout)
//                .padding(.leading, space: .smallL)
//                .padding(.top, space: .smallS)

            DashboardsCarouselView(
                editMode: $viewModel.editModel,
                dashboards: $viewModel.dashboards,
                selectedDashboard: $viewModel.selectedDashboard,
                dashboardDidEdit: viewModel.didSelectEdit,
                dashboardDidRemove: viewModel.removeDashboard,
                addDidSelect: viewModel.didSelectAdd
            )
            .padding(.top, space: .smallS)

//            Localizable.devices.text
//                .font(.title3)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, space: .smallL)

            Text(viewModel.selectedDashboard?.name ?? "nil")
            Text("----")
            Text(String(viewModel.entities))
            Text("----")
        }
        .navigationTitle(Localizable.hiThere.value)
        .toolbar {
            if viewModel.editModel {
                doneButton
            }
        }
    }

    private var doneButton: some View {
        Button {
            viewModel.editModel = false
        } label: {
            Localizable.done.text
        }
    }
}

#if DEBUG
import Preview

struct DashboardView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init(
                dashboardService: DashboardServiceMock(),
                entityService: EntityServiceMock()
            ))
        }
    }
}
#endif
