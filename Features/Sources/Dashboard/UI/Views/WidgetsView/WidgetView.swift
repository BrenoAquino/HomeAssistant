//
//  WidgetView.swift
//  
//
//  Created by Breno Aquino on 28/07/23.
//

import SwiftUI

protocol WidgetView: View {

    static var uniqueID: String { get }
}

enum WidgetSize {

    static func units(for id: String) -> (columns: Int, rows: Int) {
        switch id {
        case FanSliderWidgetView.uniqueID:
            return (2, 1)
        default:
            return (1, 1)
        }
    }
}
