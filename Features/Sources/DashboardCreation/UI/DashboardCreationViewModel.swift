//
//  DashboardCreationViewModel.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Combine
import Common
import Domain
import Foundation

public class DashboardCreationViewModel: ObservableObject {

    private var cancellable: Set<AnyCancellable> = []

    // MARK: Publishers

    @Published private(set) var icons: [IconUI] = IconUI.list
    @Published private(set) var selectedIconIndex: Int = 0
    @Published var dashboardName: String = ""
    @Published var iconFilterText: String = ""

    // MARK: Services

    private let dashboardService: DashboardService

    // MARK: Init

    public init(dashboardService: DashboardService) {
        self.dashboardService = dashboardService
        setupObservers()
    }

    private func setupObservers() {
        $iconFilterText
            .sink { [weak self] in self?.filterIcon($0) }
            .store(in: &cancellable)
    }
}

// MARK: - Private Methods

extension DashboardCreationViewModel {
    private func filterIcon(_ text: String) {
        guard !text.isEmpty else {
            icons = IconUI.list
            return
        }

        let result = IconUI.list.filter { icon in
            let strings = [icon.name].appended(contentsOf: icon.keywords)
            for string in strings {
                guard text.count <= string.count else { continue }
                let startIndex = string.startIndex
                let endIndex = string.index(startIndex, offsetBy: text.count)
                let range = Range(uncheckedBounds: (startIndex, endIndex))
                if string.compare(text, options: [.caseInsensitive, .diacriticInsensitive], range: range) == .orderedSame {
                    return true
                }
            }
            return false
        }
        
        icons = result.isEmpty ? IconUI.list : result
    }
}

// MARK: - Interfaces

extension DashboardCreationViewModel {

    func selectIcon(_ icon: IconUI, index: Int) {
        guard index < icons.count && index >= 0 else { return }
        selectedIconIndex = index
    }
}
