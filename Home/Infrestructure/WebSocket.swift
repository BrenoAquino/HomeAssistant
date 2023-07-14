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
    case timeOut
}

class WebSocket: NSObject {

    // MARK: Variables

    private let url: URL
    private let token: String
    private var webSocketMessage: PassthroughSubject<WebSocketMessageWrapper, Never> = .init()
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

    func listenWebSocketMessages() {
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
}

// MARK: - Private Methods

extension WebSocket {

    private func handleMessage(_ message: String) async {
        guard let data = message.data(using: .utf8) else { return }
        await handleMessage(data)
    }

    private func handleMessage(_ message: Data) async {
        guard let header = WebSocketMessageHeader(data: message) else {
            return
        }

        switch header.type {
        case .authRequired:
            do {
                let message = try AuthenticationMessage(accessToken: token).toJSON()
                let wsMessage = URLSessionWebSocketTask.Message.string(message)
                try await webSocket.send(wsMessage)
            } catch let error as DecodingError {
                Logger.log(level: .error, "Error encoding authentication message: \(error.localizedDescription)")
            } catch {
                Logger.log(level: .error, "Error sending access token: \(error.localizedDescription)")
            }
        default:
            webSocketMessage.send((header, message))
        }
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocket: URLSessionWebSocketDelegate {

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {}

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?
    ) {}
}

// MARK: - Data.WebSocketProvider

extension WebSocket: WebSocketProvider {

    var messageReceived: AnyPublisher<WebSocketMessageWrapper, Never> {
        webSocketMessage.eraseToAnyPublisher()
    }

    func send<Message: Encodable & WebSocketMessage, Response: Decodable>(
        message: Message
    ) async throws -> ResultWebSocketMessage<Response> {
        let wrapper: (CheckedContinuation<ResultWebSocketMessage<Response>, Error>) -> Void  = { [self] continuation in
            responseCancellable = webSocketMessage
                .timeout(.seconds(5), scheduler: DispatchQueue.main)
                .filter { $0.header.id == message.id }
                .compactMap { ResultWebSocketMessage<Response>(data: $0.data) }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        continuation.resume(throwing: WebSocketError.timeOut)
                    }
                }, receiveValue: { [weak self] messageData in
                    continuation.resume(with: .success(messageData))
                    self?.responseCancellable?.cancel()
                    self?.responseCancellable = nil
                })
        }
        return try await withCheckedThrowingContinuation(wrapper)
    }
}

// MARK: - Decodable+init

private extension Decodable {

    init?(data: Data) {
        guard let header = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = header
    }
}

// MARK: - Encodable+JSON Inline

private extension Encodable {

    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try encoder.encode(self)
        let result = String(decoding: data, as: UTF8.self)
        return result
    }
}
