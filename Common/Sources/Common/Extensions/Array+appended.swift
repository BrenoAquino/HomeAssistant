//
//  File.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Foundation

public extension Array {

    func appended(_ newElement: Element) -> Self {
        var clone = self
        clone.append(newElement)
        return clone
    }

    func appended(contentsOf array: Array) -> Self {
        var clone = self
        clone.append(contentsOf: array)
        return clone
    }
}
