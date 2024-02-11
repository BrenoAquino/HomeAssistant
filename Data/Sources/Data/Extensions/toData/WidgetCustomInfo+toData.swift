//
//  File.swift
//  
//
//  Created by Breno Aquino on 11/02/24.
//

import Domain
import Foundation

extension Domain.WidgetCustomInfo {
    func toData() -> WidgetCustomInfo {
        WidgetCustomInfo(
            title: title
        )
    }
}
