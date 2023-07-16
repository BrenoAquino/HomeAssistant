//
//  ValidationStatus.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public struct ValidationStatus {

    public let trigger: Validation
    public let condition: Validation
    public let action: Validation

    public struct Validation {
        
        public let valid: Bool
        public let error: String?
    }
}
