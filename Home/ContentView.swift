//
//  ContentView.swift
//  Home
//
//  Created by Breno Aquino on 13/07/23.
//

import Data
import SwiftUI

struct FetchingStates: Encodable {
    let type = "get_states"
}

struct StateR: Decodable {
    let entityID: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case state
        case entityID = "entity_id"
    }
}

struct ContentView: View {

    @State var webSocket = try! WebSocket(
        url: "ws://192.168.68.117:8123/api/websocket",
        token: Bundle.main.infoDictionary!["Auth Token"] as! String
    )

    func fetchStates() {
        Task {
            do {
                let (id, result): (Int, ResultWebSocketMessage<[StateR]>) = try await webSocket.send(message: FetchingStates())
                print(result)
            } catch {
                print(error)
            }
        }
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Fetching States") {
                fetchStates()
            }

        }
        .padding()
        .task {
            await webSocket.connect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
