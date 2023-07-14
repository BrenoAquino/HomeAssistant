//
//  URLSessionWebSocketTask+Stream.swift
//  Home
//
//  Created by Breno Aquino on 14/07/23.
//

import Foundation

extension URLSessionWebSocketTask {

    var stream: AsyncThrowingStream<URLSessionWebSocketTask.Message, Error> {
        return .init { continuation in
            Task {
                var isAlive = true
                while isAlive && closeCode == .invalid {
                    do {
                        let value = try await receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }
}
