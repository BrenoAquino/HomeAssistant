//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

protocol DashboardUI {
    var name: String { get }
    var icon: String { get }
}

extension Dashboard: DashboardUI {}
