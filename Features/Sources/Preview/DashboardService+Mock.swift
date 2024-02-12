//
//  DashboardService+Mock.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

#if DEBUG || PREVIEW
import Combine
import Domain
import Foundation

extension DashboardServiceMock {
    private static let all: [Dashboard] = [
        .mockBedroom,
        .mockLiving,
        .mockKitchen,
        .mockGarden,
        .mockSecurity
    ]

    private static var allDict: [String: Dashboard] = all.reduce(
        into: [:],
        { $0[$1.name] = $1 }
    )
}

public class DashboardServiceMock: Domain.DashboardService {
    @Published public var dashboardOrder: [String] = all.map { $0.name }
    public var dashboardOrderPublisher: AnyPublisher<[String], Never> {
        $dashboardOrder.eraseToAnyPublisher()
    }

    @Published public var dashboards: [String: Domain.Dashboard] = allDict
    public var dashboardsPublisher: AnyPublisher<[String : Domain.Dashboard], Never> {
        $dashboards.eraseToAnyPublisher()
    }

    public init() {}

    public func load() async throws {}
    public func add(dashboard: Domain.Dashboard) throws {}
    public func delete(dashboardName: String) throws {}
    public func update(dashboardName: String, dashboard: Domain.Dashboard) throws {}
    public func update(order: [String]) throws {}
}
#endif
