//
//  File.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct ConverterError: Error {
    public let message: String
    init(_ message: String) {
        self.message = message
    }
}
