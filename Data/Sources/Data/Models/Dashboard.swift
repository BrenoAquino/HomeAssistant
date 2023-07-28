//
//  Dashboard.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Foundation

public struct Dashboard: Codable {

    let name: String
    let icon: String
    let widgets: [EntityWidget]
}
