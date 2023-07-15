//
//  ResultWebSocketMessage.swift
//  
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

struct AnyDecodable: Decodable {}

public struct ResultWebSocketMessage<Model: Decodable>: Decodable {

    typealias Model = AnyDecodable

    public var type: WebSocketMessageType
    /// Whether the command was executed successfully or not
    public let success: Bool
    /// Custom data for each command
    public let result: Model?
}

// MARK: Utils

extension ResultWebSocketMessage {

    func returnSuccessOrThrowAnError(error: Error = WebSocketProviderError.unknown) throws -> Model {
        if success, let result {
            return result
        } else {
            throw error
        }
    }

    func throwIfError(error: Error = WebSocketProviderError.unknown) throws {
        guard !success || result == nil else { return }
        throw error
    }
}
