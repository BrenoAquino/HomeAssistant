//
//  File.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Foundation

extension WidgetEditMode: Equatable {
    
    public static func == (lhs: WidgetEditMode, rhs: WidgetEditMode) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}
