//
//  ConfigViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import Domain
import Foundation
import SwiftUI
import Preview

class ConfigViewModelPreview: ConfigViewModel {

    var delegate: ConfigExternalFlow?
    @Published private(set) var entities: [any Entity] = EntityMock.all
    @Published var hiddenEntityIDs: Set<String> = [EntityMock.ledDeskLight.id]
    @Published var entityFilterText: String = ""

    func close() { print("close") }
}

#endif
