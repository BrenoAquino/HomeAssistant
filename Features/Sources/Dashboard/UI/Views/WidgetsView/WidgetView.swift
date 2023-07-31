//
//  WidgetView.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI
import Domain

protocol WidgetView: View {

    static var uniqueID: String { get }
    static var units: (columns: Int, rows: Int) { get }
}

enum WidgetSize {

    static func units(for id: String, entity: any Entity) -> (columns: Int, rows: Int) {
        switch entity {
        case is LightEntity:
            return unitsForLightWidgets(id)
        case is FanEntity:
            return unitsForFanWidgets(id)
        default:
            return (1, 1)
        }
    }

    private static func unitsForLightWidgets(_ id: String) -> (columns: Int, rows: Int) {
        switch id {
        default:
            return (1, 1)
        }
    }

    private static func unitsForFanWidgets(_ id: String) -> (columns: Int, rows: Int) {
        switch id {
        case FanSliderWidgetView.uniqueID:
            return FanSliderWidgetView.units
        default:
            return (1, 1)
        }
    }
}
