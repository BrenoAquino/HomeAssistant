//
//  LaunchViewModel.swift
//
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

public protocol LaunchExternalFlow: AnyObject {

    func launchFinished()
}

public protocol LaunchViewModel: ObservableObject {

    var delegate: LaunchExternalFlow? { get set }

    func startConfiguration() async
}
