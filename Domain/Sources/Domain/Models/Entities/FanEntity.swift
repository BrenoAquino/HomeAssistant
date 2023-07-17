//
//  FanEntity.swift
//  
//
//  Created by Breno Aquino on 16/07/23.
//

import Foundation

public class FanEntity: Entity {

    public let percentage: Double?
    public let percentageStep: Double?

    public init(
        id: String,
        name: String,
        state: EntityState,
        percentage: Double? = nil,
        percentageStep: Double? = nil
    ) {
        self.percentage = percentage
        self.percentageStep = percentageStep
        super.init(id: id, name: name, domain: .fan, state: state)
    }
}
