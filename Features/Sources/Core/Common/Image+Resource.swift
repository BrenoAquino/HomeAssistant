//
//  Image+Resource.swift
//  
//
//  Created by Breno Aquino on 17/07/23.
//

import SwiftUI

extension Image {

    init(packageResource resource: Resources) {
        guard
            let path = Bundle.module.path(forResource: resource.name, ofType: resource.fileType),
            let image = UIImage(contentsOfFile: path)
        else {
            self.init(resource.name)
            return
        }
        self.init(uiImage: image)
    }
}
