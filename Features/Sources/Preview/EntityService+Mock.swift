//
//  EntityService+Mock.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

#if DEBUG
import Domain
import Foundation

public class EntityServiceMock: Domain.EntityService {
    public var entities: Domain.Entities = .init()

    public init() {}

    public func trackEntities() async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(2))
        }
    }

    public func updateEntity(_ entityID: String, service: Domain.EntityActionService) async throws {

    }
}

#endif
