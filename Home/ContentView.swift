//
//  ContentView.swift
//  Home
//
//  Created by Breno Aquino on 13/07/23.
//

import Data
import SwiftUI

struct ContentView: View {

    @ObservedObject private var contentViewModel: ContentViewModel = .init()

    var body: some View {
        contentViewModel
            .coordinatorFactory
            .launch()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
