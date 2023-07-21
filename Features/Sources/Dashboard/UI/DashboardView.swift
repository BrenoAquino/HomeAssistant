//
//  DashboardView.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

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
            Localizable.welcome.text
                .foregroundColor(SystemColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.leading, space: .smallL)
                .padding(.top, space: .smallS)

            DashboardsCarouselView(
                editMode: $viewModel.editModel,
                dashboards: $viewModel.dashboards,
                selectedDashboard: $viewModel.selectedDashboard,
                dashboardDidEdit: viewModel.didSelectEdit,
                dashboardDidRemove: viewModel.removeDashboard,
                addDidSelect: viewModel.didSelectAdd
            )
            .padding(.top, space: .smallS)

            entities
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

    private var entities: some View {
        LightView(entity: $entity)
            .frame(width: 150, height: 150)
    }

    struct LightEntityMock: LightEntityUI {
        let name: String
        let icon: String = "lamp.ceiling.inverse"
        var lightState: LightStateUI = .off
    }

    @State var entity = LightEntityMock(name: "Trilho")
    @State var isOn = false
}

#if DEBUG
import Preview

struct DashboardView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            DashboardView(viewModel: .init(dashboardService: DashboardServiceMock()))
        }
    }
}
#endif
