//
//  File.swift
//  
//
//  Created by Breno Aquino on 24/07/23.
//

import SwiftUI
import Combine

struct Toast<ContentView: View>: ViewModifier {

    @Binding var showToast: Bool

    let config: ToastConfig
    let onDismiss: (() -> Void)?

    private var toastContent: ContentView
    private let maxDelta: CGFloat = 20

    // MARK: States

    @State private var timer: Timer?
    @State private var offset: CGSize = .zero
    @State private var delta: CGFloat = 0
    @State private var isInit = false
    @State private var viewState = false

    // MARK: - Init

    public init(
        showToast: Binding<Bool>,
        config: ToastConfig,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> ContentView
    ) {
        self._showToast = showToast
        self.config = config
        self.onDismiss = onDismiss
        self.toastContent = content()
    }

    // MARK: - Views

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { [self] in
                delta = 0

                switch config.alignment {
                case .top:
                    if $0.translation.height <= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)

                case .bottom:
                    if $0.translation.height >= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)
                }
            }
            .onEnded { [self] _ in
                if delta >= maxDelta {
                    return dismiss()
                }
                offset = .zero
            }
    }

    @ViewBuilder
    private var toastRenderContent: some View {
        if showToast {
            toastContent
                .padding(.leading, space: .horizontal)
                .padding(.trailing, space: .normal)
                .padding(.vertical, space: .smallL)
                .background {
                    DSColor.gray6
                }
                .clipShape(Capsule())
                .shadow(radius: .normal)
                .modifier(ToastModifier(showToast: $showToast, config: config))
                .gesture(dragGesture)
                .onTapGesture(perform: dismissOnTap)
                .onAppear(perform: startDismissTimer)
                .onDisappear { isInit = false }
                .onReceive(Just(showToast), perform: update)
        }
    }

    func body(content: Content) -> some View {
        content
            .overlay(toastRenderContent, alignment: config.alignment.alignement)
    }
}

// MARK: - Dismiss

extension Toast {

    private func dismiss() {
        withAnimation(config.animation) {
            timer?.invalidate()
            timer = nil
            showToast = false
            viewState = false
            offset = .zero
            onDismiss?()
        }
    }

    private func dismissOnTap() {
        guard config.dismissOnTap else {
            return
        }
        dismiss()
    }

    private func update(state: Bool) {
        guard state != viewState else {
            return
        }
        viewState = state

        if isInit, viewState {
            dismissAfterTimeout()
        }
    }
}

// MARK: - Timer

extension Toast {

    private func startDismissTimer() {
        dismissAfterTimeout()
        isInit = true
    }

    private func dismissAfterTimeout() {
        guard let timeout = config.hideAfter, showToast else {
            return
        }

        DispatchQueue.main.async { [self] in
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { _ in dismiss() })
        }
    }
}

#if DEBUG
struct Toast_Preview: PreviewProvider {

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
    }
}
#endif
