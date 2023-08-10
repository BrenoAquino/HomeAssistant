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

public enum WidgetViewList {

    public static let light: [any WidgetView.Type] = [
        LightWidgetView.self,
    ]

    public static let fan: [any WidgetView.Type] = [
        FanWidgetView.self,
        FanSliderWidgetView.self,
    ]
}

public enum WidgetSize {

    private static let singleUnit = (1, 1)

    public static func units(for id: String, entity: any Entity) -> (columns: Int, rows: Int) {
        switch entity {
        case is LightEntity:
            return findUnits(id, WidgetViewList.light)
        case is FanEntity:
            return findUnits(id, WidgetViewList.fan)
        default:
            return singleUnit
        }
    }

    private static func findUnits(_ id: String, _ widgetViewsList: [any WidgetView.Type]) -> (columns: Int, rows: Int) {
        for view in widgetViewsList {
            if id == view.uniqueID {
                return view.units
            }
        }
        return singleUnit
    }
}
