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

    func launchFinished()
}

public enum LaunchViewModelState {

    case loading
    case error
}

public protocol LaunchViewModel: ObservableObject {

    var delegate: LaunchExternalFlow? { get set }
    var state: LaunchViewModelState { get }
    var toastData: DefaultToastDataContent? { get set }

    func startConfiguration() async
}
