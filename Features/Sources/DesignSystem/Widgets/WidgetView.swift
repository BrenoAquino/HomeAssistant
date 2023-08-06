//
//  WidgetView.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI
import Domain

public protocol WidgetView: View {

    static var uniqueID: String { get }
    static var units: (columns: Int, rows: Int) { get }
}

public enum WidgetSize {

    private static let singleUnit = (1, 1)

    static func units(for id: String, entity: any Entity) -> (columns: Int, rows: Int) {
        switch entity {
        case is LightEntity:
            return unitsForLightWidgets(id)
        case is FanEntity:
            return unitsForFanWidgets(id)
        default:
            return singleUnit
        }
    }

    private static func unitsForLightWidgets(_ id: String) -> (columns: Int, rows: Int) {
        switch id {
        case LightWidgetView.uniqueID:
            return LightWidgetView.units
        default:
            return singleUnit
        }
    }

    private static func unitsForFanWidgets(_ id: String) -> (columns: Int, rows: Int) {
        switch id {
        case FanWidgetView.uniqueID:
            return FanWidgetView.units
        case FanSliderWidgetView.uniqueID:
            return FanSliderWidgetView.units
        default:
            return singleUnit
        }
    }
}
