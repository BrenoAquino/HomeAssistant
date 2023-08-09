//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

#if DEBUG
import Foundation
import Preview
import Domain

class EntitySelectionViewModelPreview: EntitySelectionViewModel {

    weak var delegate: EntitySelectionExternalFlow?
    var entities: [AnyEntity] = EntityMock.all.map { AnyEntity(entity: $0) }
    var entityFilterText: String = ""
    var domains: [EntityDomain] = EntityDomain.allCases
    var selectedDomainsNames: Set<String> = Set(EntityDomain.allCases.map { $0.rawValue })

    func close() {}
}
#endif
