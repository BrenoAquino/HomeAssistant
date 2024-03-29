//
//  LoadingView.swift
//  
//
//  Created by Breno Aquino on 16/06/23.
//

import SwiftUI

public struct LoadingView: View {

    public init() {}

    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(2)
    }
}
