//
//  File.swift
//  
//
//  Created by Breno Aquino on 25/07/23.
//

import SwiftUI

public enum DefaultToastType {

    case info
    case warning
    case error
    case none

    var icon: String? {
        switch self {
        case .none:
            return nil
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

    let type: DefaultToastType
    let title: String?
    let message: String?

    public init(type: DefaultToastType, title: String?, message: String?) {
        self.type = type
        self.title = title
        self.message = message
    }

    public var body: some View {
        HStack(spacing: .smallL) {
            if let icon = type.icon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.iconSize)
                    .foregroundColor(type.iconColor)
            }

            VStack(alignment: .center, spacing: .smallS) {
                if let title {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(DSColor.label)
                }
                if let message {
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
        backdrop: DSColor.gray6,
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
                DefaultToastView(
                    type: .error,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                )
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(
                    type: .info,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                )
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(
                    type: .warning,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                )
            }

        VStack { }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast(
                isPresented: .init(get: { showToast }, set: { _ in }),
                config: config
            ) {
                DefaultToastView(
                    type: .none,
                    title: "Deletion Error",
                    message: "We were not able to perform your request. Try again later"
                )
            }
    }
}
#endif
