//
//  LaunchViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import DesignSystem
import Preview
import SwiftUI

class LaunchViewModelPreview: LaunchViewModel {

    var delegate: LaunchExternalFlow?
    var state: LaunchViewModelState
    var toastData: DefaultToastDataContent?

    init(state: LaunchViewModelState) {
        self.state = state
    }

    func startConfiguration() async {
        await MainActor.run {
            self.state = .loading
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .error
        }
    }
}
#endif
