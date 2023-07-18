//
//  File.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import Domain
import Foundation

protocol DashboardUI: Identifiable {
    var name: String { get }
    var icon: String { get }
}

extension DashboardUI {
    public var id: String { name }
}

// MARK: Dashboard

extension Dashboard: DashboardUI {}
