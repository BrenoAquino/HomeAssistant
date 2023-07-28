//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI

protocol EntityWidgetView: View {

    var uniqueID: String { get }
    var xUnit: Int { get }
    var yUnit: Int { get }
}

