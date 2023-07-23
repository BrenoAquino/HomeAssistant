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
        let currentString = folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
        let stringToCompare = string.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
        return currentString.contains(stringToCompare)
    }
}

public extension Array<String> {

    func contains(_ string: String, options: String.CompareOptions = []) -> Bool {
        guard !string.isEmpty else { return true }
        for element in self {
            guard string.count <= element.count else { continue }
            if element.contains(string, options: options) {
                return true
            }
        }
        return false
    }
}
