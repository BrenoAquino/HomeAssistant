//
//  ValidationRepository.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol ValidationRepository {

    func validateConfig() async throws -> ValidationStatus
}
