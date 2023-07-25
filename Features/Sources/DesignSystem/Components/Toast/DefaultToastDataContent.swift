//
//  DefaultToastDataContent.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import Foundation

public struct DefaultToastDataContent {

    let type: DefaultToastType
    let title: String?
    let message: String?

    public init(type: DefaultToastType, title: String?, message: String?) {
        self.type = type
        self.title = title
        self.message = message
    }
}
