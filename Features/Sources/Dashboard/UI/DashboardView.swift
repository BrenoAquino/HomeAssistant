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

            DashboardsCarouselView(
                editMode: $viewModel.editModel,
                dashboards: $viewModel.dashboards,
                selectedDashboard: $viewModel.selectedDashboard,
                dashboardDidEdit: viewModel.didSelectEdit,
                addDidSelect: viewModel.didSelectAdd
            )
            .padding(.top, space: .smallS)

//            Localizable.devices.text
//                .font(.title3)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal, space: .smallL)

//            Text(viewModel.selectedDashboard?.name ?? "nil")
//            Text("----")
//            Text(String(viewModel.entities))
//            Text("----")
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

    class FakeViewModel: DashboardViewModel {
        var didSelectAddDashboard: (() -> Void)?
        var didSelectEditDashboard: ((Domain.Dashboard) -> Void)?

        var editModel: Bool = false
        var selectedDashboard: Dashboard? = nil
        var dashboards: [Dashboard] = []

        func didSelectAdd() {}
        func didSelectEdit(_ dashboard: Dashboard) {}
    }

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: FakeViewModel())
        }
    }
}
#endif
