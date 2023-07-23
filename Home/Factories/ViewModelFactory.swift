////
////  ViewModelFactory.swift
////  Home
////
////  Created by Breno Aquino on 17/07/23.
////
//
//import Foundation
//import Launch
//import Dashboard
//import DashboardCreation
//
//class ViewModelFactory {
//
//    let servicesFactory: ServicesFactory
//
//    init(servicesFactory: ServicesFactory) {
//        self.servicesFactory = servicesFactory
//    }
//    
//    func launch() -> LaunchViewModel {
//        LaunchViewModel(entityService: servicesFactory.entity(), dashboardService: servicesFactory.dashboard())
//    }
//
//    func dashboard() -> DashboardViewModel {
//        DashboardViewModel(dashboardService: servicesFactory.dashboard(), entityService: servicesFactory.entity())
//    }
//
//    func dashboardCreation(mode: DashboardCreationMode) -> DashboardCreationViewModel {
//        DashboardCreationViewModel(
//            dashboardService: servicesFactory.dashboard(),
//            entitiesService: servicesFactory.entity(),
//            mode: mode
//        )
//    }
//}
