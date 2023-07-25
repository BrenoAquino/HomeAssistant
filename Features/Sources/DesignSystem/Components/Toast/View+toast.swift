//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

public extension View {

    func toast<ToastContent: View>(
        isPresented: Binding<Bool>,
        config: ToastConfig,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> ToastContent
    ) -> some View {
        modifier(Toast(showToast: isPresented, config: config, onDismiss: onDismiss, content: content))
    }

    func toast(
        isPresented: Binding<Bool>,
        type: DefaultToastType,
        title: String? = nil,
        message: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(Toast(
            showToast: isPresented,
            config: .default,
            onDismiss: onDismiss,
            content: { DefaultToastView(contentData: .init(type: type, title: title, message: message)) }
        ))
    }

    func toast(data: Binding<DefaultToastDataContent?>, onDismiss: (() -> Void)? = nil) -> some View {
        let bindingProxy = Binding<Bool>(
            get: { data.wrappedValue != nil },
            set: { if !$0 { data.wrappedValue = nil } }
        )
        return modifier(Toast(
            showToast: bindingProxy,
            config: .default,
            onDismiss: onDismiss,
            content: {
                if let data = data.wrappedValue {
                    DefaultToastView(contentData: data)
                }
            }
        ))
    }
}
