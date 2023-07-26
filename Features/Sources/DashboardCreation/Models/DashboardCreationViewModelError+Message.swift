//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import Foundation

extension DashboardCreationViewModelError {

    var message: String {
        switch self {
        case .missingName:
            return Localizable.missingNameError.value
        case .nameAlreadyExists:
            return Localizable.nameAlreadyExistsError.value
        case .missingIcon:
            return Localizable.missingIconError.value
        case .missingEntities:
            return Localizable.missingEntitiesError.value
        }
    }
}

