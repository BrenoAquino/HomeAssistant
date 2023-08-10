//
//  File.swift
//  
//
//  Created by Breno Aquino on 10/08/23.
//

import Domain
import Foundation

extension WidgetCustomInfo {

    func toDomain() -> Domain.WidgetCustomInfo {
        Domain.WidgetCustomInfo(title: title)
    }
}
