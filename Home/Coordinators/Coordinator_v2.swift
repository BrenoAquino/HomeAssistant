////
////  Coordinator.swift
////  Home
////
////  Created by Breno Aquino on 17/07/23.
////
//
//import SwiftUI
//
//class Coordinator_v2: ObservableObject {
//
//    private lazy var factory: Factory = .init()
//
//    // MARK: Handlers
//
////    private(set) lazy var webSocketHandler = factory.webSocketHandler(coordinator: self)
//
//    // MARK: Publishers
//
//    @Published var root: Screen2?
//    @Published var block: Screen2?
//    @Published var path = NavigationPath()
//    @Published var sheet: Screen2?
//    @Published var fullScreenCover: Screen2?
//
//    // MARK: Private Variables
//
//    private var rootViewCache: [any View] = []
//}
//
//// MARK: Present
//
//extension Coordinator_v2 {
//
//    func setRoot(_ screen: Screen2) {
//        DispatchQueue.main.async { [self] in
//            self.root = screen
//        }
//    }
//
//    func block(_ screen: Screen2) {
//        DispatchQueue.main.async { [self] in
//            self.block = screen
//        }
//    }
//
//    func push(_ screen: Screen2) {
//        DispatchQueue.main.async { [self] in
//            self.path.append(screen)
//        }
//    }
//
//    func preset(sheet: Screen2) {
//        DispatchQueue.main.async { [self] in
//            self.sheet = sheet
//        }
//    }
//
//    func preset(fullScreenCover: Screen2) {
//        DispatchQueue.main.async { [self] in
//            self.fullScreenCover = fullScreenCover
//        }
//    }
//}
//
//// MARK: Dismiss
//
//extension Coordinator_v2 {
//
//    func pop() {
//        DispatchQueue.main.async { [self] in
//            self.path.removeLast()
//        }
//    }
//
//    func popToRoot() {
//        DispatchQueue.main.async { [self] in
//            self.path.removeLast(path.count)
//        }
//    }
//
//    func dismiss() {
//        DispatchQueue.main.async { [self] in
//            self.sheet = nil
//            self.fullScreenCover = nil
//        }
//    }
//
//    func dismissBlock() {
//        DispatchQueue.main.async { [self] in
//            self.block = nil
//        }
//    }
//}
//
//// MARK: Builds
//
//extension Coordinator_v2 {
//
//    @ViewBuilder
//    func rootView() -> some View {
//        AnyView(root!.view)
//    }
//}
