////
////  DashboardCreationViewModel.swift
////
////
////  Created by Breno Aquino on 18/07/23.
////
//
//import Combine
//import Common
//import Domain
//import Foundation
//import SwiftUI
//
//// MARK: - Interface
//
//public enum DashboardCreationMode: Equatable {
//    case creation
//    case edit(_ dashboard: Dashboard)
//}
//
//public protocol DashboardCreationViewModel: ObservableObject {
//
//    var mode: DashboardCreationMode { get }
//
//    var dashboardName: String { get set }
//
//    var icons: [IconUI] { get }
//    var selectedIcon: IconUI? { get set }
//    var iconFilterText: String { get set }
//
//    var entities: [any Entity] { get }
//    var selectedEntitiesIDs: Set<String> { get set }
//    var entityFilterText: String { get set }
//
//    var domains: [EntityDomain] { get }
//    var selectedDomainsNames: Set<String> { get set }
//}
//
//// MARK: - Implementation
//
//enum DashboardCreationViewModelImplError: Error {
//    case missingName
//    case nameAlreadyExists
//    case missingIcon
//    case missingEntities
//}
//
//public class DashboardCreationViewModelImpl<DashboardS: DashboardService, EntityS: EntityService>: DashboardCreationViewModel {
//
//    private var allEntities: [any Entity] = []
//    private var cancellable: Set<AnyCancellable> = []
//    private var originalName: String = ""
//    public let mode: DashboardCreationMode
//
//    // MARK: Redirects
//
//    public var didFinish: (() -> Void)?
//    public var didClose: (() -> Void)?
//
//    // MARK: Publishers
//
//    @Published public var dashboardName: String = ""
//
//    @Published public private(set) var icons: [IconUI] = IconUI.list
//    @Published public var selectedIcon: IconUI?
//    @Published public var iconFilterText: String = ""
//
//    @Published public var selectedEntitiesIDs: Set<String> = []
//    @Published public var entityFilterText: String = ""
//
//    @Published public private(set) var domains: [EntityDomain] = []
//    @Published public var selectedDomainsNames: Set<String> = []
//
//    // MARK: Services
//
//    @ObservedObject private var dashboardService: DashboardS
//    @ObservedObject private var entitiesService: EntityS
//
//    // MARK: Gets
//
//    @Published public var entities: [any Entity]
//
//    // MARK: Init
//
//    public init(dashboardService: DashboardS, entitiesService: EntityS, mode: DashboardCreationMode) {
//        self.dashboardService = dashboardService
//        self.entitiesService = entitiesService
//        self.mode = mode
//
//        setupData(mode)
//        setupObservers()
//    }
//}
//
//// MARK: - Setups
//
//extension DashboardCreationViewModelImpl {
//
//    private func setupData(_ mode: DashboardCreationMode) {
//        guard case .edit(let dashboard) = mode else { return }
//
//        originalName = dashboard.name
//        dashboardName = dashboard.name
//        selectedIcon = icons.first(where: { $0.name == dashboard.icon })
//        selectedEntitiesIDs = Set(dashboard.entitiesIDs)
//    }
//
//    private func setupObservers() {
//        serviceObservers()
//        uiObservers()
//    }
//
//    private func serviceObservers() {
//    }
//
//    private func uiObservers() {
//        $iconFilterText
//            .sink { [weak self] in self?.filterIcon($0) }
//            .store(in: &cancellable)
//
//        Publishers
//            .CombineLatest($entityFilterText, $selectedDomainsNames)
//            .sink { [weak self] in self?.filterEntity($0, domainNames: $1) }
//            .store(in: &cancellable)
//    }
//}
//
//// MARK: - Private Methods
//
//extension DashboardCreationViewModelImpl {
//
//    private func filterIcon(_ text: String) {
//        guard !text.isEmpty else {
//            icons = IconUI.list
//            return
//        }
//        let result = IconUI.list.filter { icon in
//            [icon.name].appended(contentsOf: icon.keywords).contains(text, options: [.caseInsensitive, .diacriticInsensitive])
//        }
//        icons = result.isEmpty ? IconUI.list : result
//    }
//
//    private func filterEntity(_ text: String, domainNames: Set<String>) {
//        let allEntities = sortedEntities.map { $0.toUI() }
//        guard !text.isEmpty || !domainNames.isEmpty else {
//            entities = allEntities
//            return
//        }
//        let result = allEntities.filter { entity in
//            let nameCheck = [entity.name, entity.domainUI.name].contains(text, options: [.caseInsensitive, .diacriticInsensitive])
//            let domainCheck = domainNames.contains(entity.domainUI.name)
//            return nameCheck && domainCheck
//        }
//        entities = result.isEmpty ? allEntities : result
//    }
//
//    private func createDashboard() throws -> Dashboard {
//        let name = dashboardName
//        guard !name.isEmpty else {
//            throw DashboardCreationViewModelImplError.missingName
//        }
//
//        if name != originalName {
//            guard !dashboardService.dashboards.contains(where: { $0.name == name }) else {
//                throw DashboardCreationViewModelImplError.nameAlreadyExists
//            }
//        }
//
//        guard let selectedIcon else {
//            throw DashboardCreationViewModelImplError.missingIcon
//        }
//
//        guard !selectedEntitiesIDs.isEmpty else {
//            throw DashboardCreationViewModelImplError.missingEntities
//        }
//
//        return Dashboard(name: name, icon: selectedIcon.name, entities: Array(selectedEntitiesIDs))
//    }
//}
//
//// MARK: - Interfaces
//
//extension DashboardCreationViewModelImpl {
//
//    func createOrUpdateDashboard() {
//        do {
//            let dashboard = try createDashboard()
//            if mode == .creation {
//                try dashboardService.add(dashboard: dashboard)
//            } else {
//                try dashboardService.update(dashboardName: originalName, dashboard: dashboard)
//            }
//            didFinish?()
//        } catch {
//            Logger.log(level: .error, error.localizedDescription)
//        }
//    }
//
//    func close() {
//        didClose?()
//    }
//}
