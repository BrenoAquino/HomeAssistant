//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import SwiftUI

public enum WidgetEditMode {

    case creation
    case edit(entity: any Entity)
}

public protocol WidgetEditViewModel: ObservableObject {

    var mode: WidgetEditMode { get }

    func entitySelection() -> any View
    func uiSelection(_ entity: any Entity) -> any View
}

public class WidgetEditViewModelImpl<EntityS: EntityService>: WidgetEditViewModel {

    public var mode: WidgetEditMode
    private var entityService: EntityS

    public init(entityService: EntityS, mode: WidgetEditMode) {
        self.entityService = entityService
        self.mode = mode
    }

    public func entitySelection() -> any View {
        let viewModel = EntitySelectionViewModelImpl(entityService: entityService)
        return WidgetEntitySelectionView(viewModel: viewModel)
    }

    public func uiSelection(_ entity: any Entity) -> any View {
        let viewModel = WidgetUISelectionViewModelImpl(entity: entity)
        return WidgetUISelectionView(viewModel: viewModel)
    }
}

public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            root
        }
    }

    @ViewBuilder public var root: some View {
        switch viewModel.mode {
        case .creation:
            AnyView(viewModel.entitySelection())
                .navigationDestination(for: AnyEntity.self) { elem in
                    AnyView(viewModel.uiSelection(elem.entity))
                }

        case .edit(let entity):
            AnyView(viewModel.uiSelection(entity))
        }
    }
}

//#if DEBUG
//struct WidgetEditView_Preview: PreviewProvider {
//
//    static var previews: some View {
//        WidgetEditView(viewModel: .init())
//    }
//}
//#endif
