//
//  Publisher+decodeKeyPath.swift
//
//
//  Created by Breno Aquino on 06/02/22.
//

import Foundation
import Combine

public extension Publisher where Output == Data {

    func decode<
        Item: Decodable,
        Coder: TopLevelDecoder
    >(
        type: Item.Type,
        decoder: Coder,
        atKeyPath keyPath: String?
    ) -> Publishers.Decode<Publishers.TryMap<Self, Self.Output>, Item, Coder> where Self.Output == Coder.Input {
        return tryMap { value in
            if let keyPath = keyPath {
                let json = try? JSONSerialization.jsonObject(with: value, options: []) as? NSDictionary
                if let result = json?.value(forKeyPath: keyPath), let nestedJson = try? JSONSerialization.data(withJSONObject: result) {
                    return nestedJson
                }
            }
            return value
        }
        .decode(type: type, decoder: decoder)
    }
}
