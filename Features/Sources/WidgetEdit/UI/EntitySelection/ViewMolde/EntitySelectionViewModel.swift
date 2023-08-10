//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import Foundation

protocol EntitySelectionExternalFlow: AnyObject {

    func didClose()
}

protocol EntitySelectionViewModel: ObservableObject {

    var delegate: EntitySelectionExternalFlow? { get set }
    var entities: [AnyEntity] { get }
    var entityFilterText: String { get set }
    var domains: [Domain.EntityDomain] { get }
    var selectedDomainsNames: Set<String> { get set }

    func close()
}
