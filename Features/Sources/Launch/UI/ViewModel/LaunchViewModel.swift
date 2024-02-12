//
//  LaunchViewModel.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import DesignSystem
import Domain
import Foundation

public protocol LaunchExternalFlow {
    /// When the launch had finish
    func launchFinished()
}

public enum LaunchViewModelState {
    /// Loading state
    case loading
    /// Error state
    case error
}

public protocol LaunchViewModel: ObservableObject {
    /// External flow that are not handler within the module
    var externalFlows: LaunchExternalFlow? { get set }
    /// Current screen state
    var state: LaunchViewModelState { get }
    /// Toast data to show over the screen
    var toastData: DefaultToastDataContent? { get set }
    /// Configure all the components that is required
    func configure() async
}
