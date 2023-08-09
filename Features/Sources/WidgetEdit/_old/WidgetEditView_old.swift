////
////  WidgetEditView.swift
////
////
////  Created by Breno Aquino on 09/08/23.
////
//
//import DesignSystem
//import SwiftUI
//
//public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {
//
//    @ObservedObject private var viewModel: ViewModel
//
//    public init(viewModel: ViewModel) {
//        self.viewModel = viewModel
//    }
//
//    public var body: some View {
//        VStack(spacing: .zero) {
//            steps
//        }
//        .navigationTitle(title)
//        .toolbar {
//            closeButton
//        }
//    }
//
//    private var title: String {
//        switch viewModel.currentStep {
//        case .entitySelection:
//            return Localizable.entitySelectionTitle.value
//        case .uiSelection:
//            return Localizable.entitySelectionTitle.value
//        }
//    }
//
//    private var closeButton: some View {
//        Button(action: viewModel.close) {
//            SystemImages.close
//                .imageScale(.large)
//                .foregroundColor(DSColor.label)
//        }
//        .foregroundColor(DSColor.label)
//    }
//
//    private var steps: some View {
//        TabView(selection: $viewModel.currentStep) {
////            WidgetEntitySelectionView(
////                entities: viewModel.entities,
////                entitySearchText: $viewModel.entityFilterText,
////                domains: viewModel.domains,
////                selectedDomains: $viewModel.selectedDomainsNames,
////                didSelectEntity: viewModel.didSelectEntity
////            )
////            .tag(WidgetEditStep.entitySelection)
////            .disablePageSwipe()
////
////            if let entity = viewModel.entity {
////                WidgetUISelectionView(
////                    entity: entity,
////                    widgetTitle: $viewModel.widgetTitle,
////                    viewIDs: viewModel.viewIDs,
////                    selectedViewID: $viewModel.selectedViewID,
////                    createOrUpdateWidget: viewModel.createOrUpdateWidget
////                )
////                .tag(WidgetEditStep.uiSelection)
////                .disablePageSwipe()
////            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//    }
//}
//
//private extension View {
//
//    func disablePageSwipe() -> some View {
//        self
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .contentShape(Rectangle())
//            .gesture(DragGesture())
//    }
//}
//
//#if DEBUG
//struct WidgetEditView_v2_Preview: PreviewProvider {
//
//    static var previews: some View {
//        NavigationStack {
//            WidgetEditView(viewModel: WidgetEditViewModelPreview())
//        }
//    }
//}
//#endif
