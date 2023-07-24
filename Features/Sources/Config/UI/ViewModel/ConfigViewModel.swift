//
//  ConfigViewModel.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import Foundation

public protocol ConfigViewModel: ObservableObject {

    var entities: [any Entity] { get }
    var hiddenEntityIDs: Set<String> { get set }
}
