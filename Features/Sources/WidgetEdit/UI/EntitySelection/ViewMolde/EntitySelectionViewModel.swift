//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import Foundation

protocol EntitySelectionViewModel: ObservableObject {

    var entities: [AnyEntity] { get }
    var entityFilterText: String { get set }
    var domains: [Domain.EntityDomain] { get }
    var selectedDomainsNames: Set<String> { get set }

    func didSelectEntity(_ entity: any Entity)
    func close()
}
