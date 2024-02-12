//
//  Resources.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

enum Resources {
    case whiteLogo
}

extension Resources {
    var name: String {
        switch self {
        case .whiteLogo:
            return "home-assistant-white-logo"
        }
    }

    var fileType: String {
        switch self {
        case .whiteLogo:
            return "png"
        }
    }
}
