//
//  LaunchCoordinatorViewModel.swift
//  Home
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation
import Launch

class LaunchCoordinatorViewModel: ObservableObject {
    
    let launchViewModel: LaunchViewModel

    init(launchViewModel: LaunchViewModel) {
        self.launchViewModel = launchViewModel
    }
}
