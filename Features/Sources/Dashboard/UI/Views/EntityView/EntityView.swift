//
//  File.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI

protocol EntityView: View {

    var xUnit: Int { get }
    var yUnit: Int { get }
    var uniqueID: String { get }
}

