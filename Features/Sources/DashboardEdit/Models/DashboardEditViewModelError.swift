//
//  DashboardEditViewModelError.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import Foundation

extension DashboardEditViewModelError {

    var message: String {
        switch self {
        case .missingName:
            return Localizable.missingNameError.value
        case .nameAlreadyExists:
            return Localizable.nameAlreadyExistsError.value
        case .missingIcon:
            return Localizable.missingIconError.value
        case .invalidNumberOfColumns:
            return Localizable.invalidNumberOfColumnsError.value
        }
    }
}

