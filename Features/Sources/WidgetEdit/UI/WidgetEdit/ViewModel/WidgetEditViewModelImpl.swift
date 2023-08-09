//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Foundation
import Domain
import SwiftUI

public class WidgetEditViewModelImpl<EntityS: EntityService>: WidgetEditViewModel {

    public var delegate: WidgetEditExternalFlow?
    public var mode: WidgetEditMode
    private var entityService: EntityS

    public init(entityService: EntityS, mode: WidgetEditMode) {
        self.entityService = entityService
        self.mode = mode
    }

    public func entitySelection() -> any View {
        let viewModel = EntitySelectionViewModelImpl(entityService: entityService)
        viewModel.delegate = self
        return WidgetEntitySelectionView(viewModel: viewModel)
    }

    public func uiSelection(_ entity: any Entity) -> any View {
        let viewModel = WidgetUISelectionViewModelImpl(entity: entity)
        return WidgetUISelectionView(viewModel: viewModel)
    }
}

extension WidgetEditViewModelImpl: EntitySelectionExternalFlow {

    func didClose() {
        delegate?.didClose()
    }
}
