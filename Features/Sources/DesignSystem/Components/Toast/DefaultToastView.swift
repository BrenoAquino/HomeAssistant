//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

public enum DefaultToastType {

    case success
    case info
    case warning
    case error
    case none

    var icon: String? {
        switch self {
        case .none:
            return nil
        case .success:
            return "checkmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "x.circle.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .success:
            return DSColor.green
        case .info:
            return DSColor.label
        case .warning:
            return DSColor.yellow
        case .error:
            return DSColor.red
        case .none:
            return DSColor.gray4
        }
    }
}

private enum Constants {

    static let iconSize: CGFloat = 16
}

public struct DefaultToastView: View {

    let contentData: DefaultToastDataContent

    public init(contentData: DefaultToastDataContent) {
        self.contentData = contentData
    }

    public var body: some View {
        HStack(spacing: .smallL) {
            if let icon = contentData.type.icon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.iconSize)
                    .foregroundColor(contentData.type.iconColor)
            }

            VStack(alignment: .center, spacing: .smallS) {
                if let title = contentData.title {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(DSColor.label)
                }
                if let message = contentData.message {
                    Text(message)
                        .font(.subheadline)
                        .lineLimit(.max)
                        .multilineTextAlignment(.center)
                        .foregroundColor(DSColor.secondaryLabel)
                }
            }
        }
    }
}

#if DEBUG
struct DefaultToastView_Preview: PreviewProvider {

    static let showToast = true
    static let config = ToastConfig(
        hideAfter: nil,
        dismissOnTap: false,
        alignment: .top,
        animation: .easeInOut,
        transition: .fade
    )

    static var previews: some View {

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(contentData: .init(
                    type: .error,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                ))
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(contentData: .init(
                    type: .info,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                ))
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(contentData: .init(
                    type: .warning,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                ))
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(contentData: .init(
                    type: .none,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                ))
            }
    }
}
#endif
