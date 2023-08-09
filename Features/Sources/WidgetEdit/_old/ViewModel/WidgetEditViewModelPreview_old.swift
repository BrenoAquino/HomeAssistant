////
////  WidgetEditViewModelPreview.swift
////  
////
////  Created by Breno Aquino on 23/07/23.
////
//
//#if DEBUG
//import DesignSystem
//import Preview
//import Domain
//
//class WidgetEditViewModelPreview: WidgetEditViewModel {
//    var mode: WidgetEditMode = .creation
//    var delegate: WidgetEditExternalFlow?
//    var toastData: DefaultToastDataContent?
//
//    var currentStep: WidgetEditStep = .entitySelection
//    var isLastStep: Bool = false
//    var isFirstStep: Bool = false
//
//    var entities: [any Entity] = EntityMock.all
//    var entityFilterText: String = ""
//    var domains: [EntityDomain] = EntityDomain.allCases
//    var selectedDomainsNames: Set<String> = Set(EntityDomain.allCases.map { $0.rawValue })
//    func didSelectEntity(_ entity: any Entity) {}
//
//    var entity: (any Entity)? = EntityMock.fan
//    var widgetTitle: String = "Fan"
//    var viewIDs: [String] = WidgetViewList.fan.map { $0.uniqueID }
//    var selectedViewID: String = "default"
//    func createOrUpdateWidget() {}
//
//    init() {}
//
//    func nextStep() {}
//    func previousStep() {}
//    func close() {}
//}
//#endif
