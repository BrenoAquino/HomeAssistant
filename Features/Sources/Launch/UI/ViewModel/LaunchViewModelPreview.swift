//
//  LaunchViewModelPreview.swift
//  
//
//  Created by Breno Aquino on 23/07/23.
//

#if DEBUG
import Preview

class LaunchViewModelPreview: LaunchViewModel {

    weak var delegate: LaunchExternalFlow?

    func startConfiguration() async {}
}
#endif
