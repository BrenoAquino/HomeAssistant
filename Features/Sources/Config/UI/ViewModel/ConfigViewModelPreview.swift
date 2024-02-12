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
    var entities: [any Entity] = [
        LightEntity.mockMainLight,
        LightEntity.mockLedDeskLight,
        LightEntity.mockLedCeilingLight,
        ClimateEntity.mock,
        SwitchEntity.mockCoffeeMachine,
        FanEntity.mock,
    ]
    var hiddenEntityIDs: Set<String> = [LightEntity.mockMainLight.id]
    var entityFilterText: String = ""

    func addEntityOnHiddenList(_ id: String) {}
    func removeEntityFromHiddenList(_ id: String) {}
}
#endif
