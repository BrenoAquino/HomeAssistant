//
//  ValidationResult.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public struct ValidationResult {

    let trigger: Validation
    let condition: Validation
    let action: Validation

    struct Validation: Decodable {
        let valid: Bool
        let error: String?
    }
}
