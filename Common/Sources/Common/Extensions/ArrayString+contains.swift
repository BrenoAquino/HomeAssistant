//
//  File.swift
//  
//
//  Created by Breno Aquino on 19/07/23.
//

import Foundation

public extension String {

    func contains(_ string: String, options: CompareOptions) -> Bool {
        guard string.count <= count else { return false }
        let endIndex = index(startIndex, offsetBy: string.count)
        let range = Range(uncheckedBounds: (startIndex, endIndex))
        return compare(string, options: [.caseInsensitive, .diacriticInsensitive], range: range) == .orderedSame
    }
}

public extension Array<String> {

    func contains(_ string: String, options: String.CompareOptions) -> Bool {
        for element in self {
            guard string.count <= element.count else { continue }
            if element.contains(string, options: options) {
                return true
            }
        }
        return false
    }
}
