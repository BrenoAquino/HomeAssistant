//
//  ObservableObject+forward.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

import Combine

public extension ObservableObject {

    func forward(_ observableObject: ObservableObjectPublisher) -> AnyCancellable {
        objectWillChange.sink { _ in
            observableObject.send()
        }
    }
}
