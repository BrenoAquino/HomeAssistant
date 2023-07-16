//
//  WebSocket.swift
//  Home
//
//  Created by Breno Aquino on 14/07/23.
//

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
    private let dispatchQueue: DispatchQueue = .init(label: "WebSocket")

    nonisolated private let topic: PassthroughSubject<WebSocketMessage, Never> = .init()
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    private lazy var webSocket = session.webSocketTask(with: url)
    private var responseCancellable: AnyCancellable?

    // MARK: Init

    init(url: String, token: String) throws {
        guard let url = URL(string: url) else {
            throw WebSocketError.invalidURL
        }
        self.url = url
        self.token = token
    }
}

// MARK: - Interfaces

extension WebSocket {

    func connect() {
        webSocket.resume()
        listenWebSocketMessages()
    }
}

// MARK: - Private Methods

extension WebSocket {

    private func listenWebSocketMessages() {
        Task {
            do {
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
                Logger.log(level: .error, "Error getting messages from the WebSocket: \(error.localizedDescription)")
            }
        }
    }

    private func handleMessage(_ message: String) async {
        guard let data = message.data(using: .utf8) else { return }
        await handleMessage(data)
    }

    private func handleMessage(_ message: Data) async {
        guard let header = try? WebSocketMessageHeader(data: message) else {
            return
        }

        switch header.type {
        case .authRequired:
            await authenticate()
        default:
            topic.send((header, message))
        }
    }

    private func authenticate() async {
        do {
            let message = try AuthenticationMessage(accessToken: token).toJSON()
            let wsMessage = URLSessionWebSocketTask.Message.string(message)
            try await webSocket.send(wsMessage)
        } catch let error as DecodingError {
            Logger.log(level: .error, "Error encoding authentication message: \(error.localizedDescription)")
        } catch {
            Logger.log(level: .error, "Error sending access token: \(error.localizedDescription)")
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocket: URLSessionWebSocketDelegate {

    private func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) async {
        print("Connected")
    }

    private func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
    ) async {
        print("Disconnected")
    }
}

// MARK: - Data.WebSocketProvider

extension WebSocket: WebSocketProvider {

    nonisolated var messageReceived: AnyPublisher<WebSocketMessage, Never> {
        topic.eraseToAnyPublisher()
    }

    func send<Message: Encodable>(message: Message) async throws -> Int {
        let (id, _): (Int, EmptyDecodable) = try await send(message: message)
        return id
    }

    func send<Message: Encodable, Response: Decodable>(
        message: Message
    ) async throws -> (id: Int, response: Response) {
        let id = latestID
        let message = WebSocketSendMessageWrapper(id: id, messageData: message)
        latestID += 1
        let data = try message.toJSON()
        try await webSocket.send(.string(data))

        let wrapper: (CheckedContinuation<ResultWebSocketMessage<Response>, Error>) -> Void  = { [self] continuation in
            var hasValue = false
            responseCancellable = topic
                .timeout(.seconds(10), scheduler: DispatchQueue.global())
                .filter { $0.header.id == message.id && $0.header.type == .getStates }
                .tryCompactMap { try ResultWebSocketMessage<Response>(data: $0.data) }
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
        
        if let result = try await withCheckedThrowingContinuation(wrapper).result {
            return (id, result)
        } else {
            throw WebSocketError.emptyData
        }
    }
}


// MARK: - Decodable+init

private extension Decodable {

    init(data: Data) throws {
        let header = try JSONDecoder().decode(Self.self, from: data)
        self = header
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
