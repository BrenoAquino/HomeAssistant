//
//  ValidationRemoteDataSource.swift
//  
//
//  Created by Breno Aquino on 15/07/23.
//

import Foundation

public protocol ValidationRemoteDataSource {

    func validateConfig() async throws -> ValidationResult
}
