//
//  ConfigViewModel.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Domain
import Foundation

public protocol ConfigExternalFlow {

    func didClose()
}

public protocol ConfigViewModel: ObservableObject {

    var delegate: ConfigExternalFlow? { get set }

    var entities: [any Entity] { get }
    var entityFilterText: String { get set }
    var hiddenEntityIDs: Set<String> { get set }

    func close()
}
