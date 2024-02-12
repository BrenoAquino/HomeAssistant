//
//  ConfigViewModel.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import Foundation

public protocol ConfigViewModel: ObservableObject {
    /// All entities
    var entities: [any Entity] { get }
    /// Filter text to modify entity list
    var entityFilterText: String { get set }
    /// List with hidden entities
    var hiddenEntityIDs: Set<String> { get }
    /// Add a new entity on hidden list
    func addEntityOnHiddenList(_ id: String)
    /// Remove a new entity on hidden list
    func removeEntityFromHiddenList(_ id: String)
}
