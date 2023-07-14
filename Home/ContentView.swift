//
//  ContentView.swift
//  Home
//
//  Created by Breno Aquino on 13/07/23.
//

import SwiftUI

struct ContentView: View {

    @State var webSocket = try! WebSocket(
        url: "ws://192.168.68.117:8123/api/websocket",
        token: Bundle.main.infoDictionary!["Auth Token"] as! String
    )

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            webSocket.connect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
