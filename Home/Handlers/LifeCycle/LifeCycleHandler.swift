//
//  LifeCycleHandler.swift
//  Home
//
//  Created by Breno Aquino on 19/07/23.
//

import Data
import Domain
import Foundation
import SwiftUI

enum AppState {
    case foreground
    case background
}

protocol LifeCycleHandler {

    func appStateDidChange(_ state: AppState)
}
