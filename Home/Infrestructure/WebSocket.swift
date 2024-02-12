//
//  WebSocket.swift
//  Home
//
//  Created by Breno Aquino on 14/07/23.
//

import Common
import Combine
import Data
import Foundation

enum WebSocketError: Error {
    case invalidURL
    case emptyData
    case timeOut
    case decodingError
    case unknown
}

actor WebSocket: NSObject {

    // MARK: Variables

    private let url: URL
    private let token: String

    private var latestID: Int = 1
    private var state: WebSocketProviderState = .offline {
        didSet { connectionStateTopic.send(state) }
    }

    private var session: URLSession?
    private var webSocket: URLSessionWebSocketTask?
    private var responseCancellable: AnyCancellable?

    nonisolated private let connectionStateTopic: PassthroughSubject<WebSocketProviderState, Never> = .init()
    nonisolated private let messageTopic: PassthroughSubject<WebSocketMessage, Never> = .init()

    // MARK: Init

    init(
        url: String,
        token: String
    ) throws {
        guard let url = URL(string: url) else {
            throw WebSocketError.invalidURL
        }
        self.url = url
        self.token = token
    }
}

// MARK: - Private Methods

extension WebSocket {

    private func listenWebSocketMessages() {
        Task {
            do {
                guard let webSocket else {
                    await disconnect()
                    return
                }

                for try await message in webSocket.stream {
                    switch message {
                    case let .string(string):
                        await handleMessage(string)
                    case let .data(data):
                        await handleMessage(data)
                    @unknown default:
                        fatalError("unknown message received")
                    }
                }
            } catch {
                await disconnect()
                Logger.log(level: .error, "Error getting messages from the WebSocket: \(error.localizedDescription)")
            }
        }
    }

    private func handleMessage(_ message: String) async {
        guard let data = message.data(using: .utf8) else { return }
        await handleMessage(data)
    }

    private func handleMessage(_ message: Data) async {
        guard let header = try? WebSocketMessageHeader(jsonData: message) else {
            return
        }
        messageTopic.send((header, message))
    }

    private func authenticateIfNeeded() async throws {
        guard state == .offline || webSocket?.state != .running else { return }

        do {
            session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            webSocket = session?.webSocketTask(with: url)

            webSocket?.resume()
            listenWebSocketMessages()

            try await withCheckedThrowingContinuation(waitAuthRequired)

            let message = try AuthenticationMessage(accessToken: token).toJSON()
            let wsMessage = URLSessionWebSocketTask.Message.string(message)
            try await webSocket?.send(wsMessage)
            state = .online
        } catch {
            await disconnect()
            throw error
        }
    }

    private func waitAuthRequired(
        _ continuation: CheckedContinuation<Void, Error>
    ) {
        var hasValue = false
        responseCancellable = messageTopic
            .timeout(.seconds(10), scheduler: DispatchQueue.global())
            .map {
                $0
            }
            .filter { $0.header.type == .authRequired }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    if !hasValue {
                        continuation.resume(throwing: WebSocketError.timeOut)
                    }
                case .failure:
                    continuation.resume(throwing: WebSocketError.unknown)
                }
            }, receiveValue: { messageData in
                hasValue = true
                continuation.resume()
            })
    }

    private func continuationHandler<Response: Decodable>(
        _ continuation: CheckedContinuation<WebSocketReceiveMessageWrapper<Response>, Error>,
        _ messageID: Int
    ) {
        var hasValue = false
        responseCancellable = messageTopic
            .timeout(.seconds(10), scheduler: DispatchQueue.global())
            .filter { $0.header.id == messageID && $0.header.type == .result }
            .tryCompactMap { try WebSocketReceiveMessageWrapper<Response>(jsonData: $0.data) }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    if !hasValue {
                        continuation.resume(throwing: WebSocketError.timeOut)
                    }
                case .failure(let failure):
                    switch failure {
                    case is DecodingError:
                        continuation.resume(throwing: WebSocketError.decodingError)
                    default:
                        continuation.resume(throwing: WebSocketError.unknown)
                    }
                }
            }, receiveValue: { messageData in
                hasValue = true
                continuation.resume(returning: messageData)
            })
    }

    private func disconnect() async {
        webSocket?.cancel()
        webSocket = nil
        state = .offline
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocket: URLSessionWebSocketDelegate {

    nonisolated func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {}

    nonisolated func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
    ) {
        Task { await disconnect() }
    }
}

// MARK: - Data.WebSocketProvider

extension WebSocket: WebSocketProvider {

    nonisolated var connectionStateChanged: AnyPublisher<WebSocketProviderState, Never> {
        connectionStateTopic.eraseToAnyPublisher()
    }

    nonisolated var messageReceived: AnyPublisher<WebSocketMessage, Never> {
        messageTopic.eraseToAnyPublisher()
    }

    @discardableResult func send<Message: Encodable>(message: Message) async throws -> Int {
        let (id, _): (Int, EmptyCodable) = try await send(message: message)
        return id
    }

    func send<Message: Encodable, Response: Decodable>(message: Message) async throws -> (id: Int, response: Response) {
        try await authenticateIfNeeded()

        let id = latestID
        let message = WebSocketSendMessageWrapper(id: id, messageData: message)
        latestID += 1
        let data = try message.toJSON()
        try await webSocket?.send(.string(data))

        let response: WebSocketReceiveMessageWrapper<Response> = try await withCheckedThrowingContinuation {
            continuationHandler($0, id)
        }
        if let result = response.result {
            return (id, result)
        } else if response.success, let emptyCodable = EmptyCodable() as? Response {
            return (id, emptyCodable)
        } else {
            throw WebSocketError.emptyData
        }
    }
}

// MARK: - Encodable+toJSON

private extension Encodable {

    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        let result = String(decoding: data, as: UTF8.self)
        return result
    }
}
