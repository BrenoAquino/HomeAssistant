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

    @Published private(set) var entities: [any Entity] = EntityMock.all
    @Published var hiddenEntityIDs: Set<String> = [EntityMock.ledDeskLight.id]
}

#endif
