//
//  WidgetEditViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Preview
import Domain

class WidgetEditViewModelPreview: WidgetEditViewModel {

    var delegate: WidgetEditExternalFlow?
    var entity: any Entity

    init(entity: any Entity) {
        self.entity = entity
    }

    func close() {}
}
#endif
