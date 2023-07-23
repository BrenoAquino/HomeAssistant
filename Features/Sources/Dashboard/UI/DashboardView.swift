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
                selectedDashboardIndex: $viewModel.selectedDashboardIndex,
                dashboardDidEdit: viewModel.didSelectEdit,
                addDidSelect: viewModel.didSelectAdd
            )
            .padding(.top, space: .smallS)
            
            Localizable.devices.text
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, space: .smallL)
                .padding(.top, space: .smallS)
            
            entitiesGrid
                .padding(.top, space: .smallS)
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
    
    private var entitiesGrid: some View {
        GeometryReader { proxy in
            let numberOfElementsInRow: Int = 3
            let space = DSSpace.smallL.rawValue
            let totalSpace = space * (CGFloat(numberOfElementsInRow) + 1)
            let size = (proxy.size.width - totalSpace) / CGFloat(numberOfElementsInRow)
            let columns = [GridItem](repeating: .init(.fixed(size), spacing: space), count: numberOfElementsInRow)
            
            LazyVGrid(columns: columns) {
                ForEach(Array(viewModel.entities.enumerated()), id: \.element.id) { index, entity in
                    Group {
                        switch entity {
                        case let light as LightEntityUI:
                            LightView(entity: .init(get: { light }, set: { _ in }))
                        default:
                            UnsupportedView(
                                name: entity.name,
                                domain: entity.domain.name
                            )
                        }
                    }
                    .frame(height: size)
                }
            }
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
