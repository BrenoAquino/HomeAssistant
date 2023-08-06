//
//  WidgetEditView.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI

public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Text("")
    }
}

#if DEBUG
struct WidgetEditView_Preview: PreviewProvider {

    static var previews: some View {

        WidgetEditView(viewModel: WidgetEditViewModelPreview())
    }
}
#endif
