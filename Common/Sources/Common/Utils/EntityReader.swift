//
//  EntityReader.swift
//
//
//  Created by Breno Aquino on 11/02/24.
//

import Foundation

enum EntityReaderError: Error {
    case missingDomain
}

public enum EntityReader {
    public static func extractDomain(_ entityID: String) throws -> String {
        guard let domain = entityID.split(separator: ".").first?.lowercased() else {
            throw EntityReaderError.missingDomain
        }
        return domain
    }
}
