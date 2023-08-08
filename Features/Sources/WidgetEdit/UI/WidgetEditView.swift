//
//  WidgetEditView.swift
//
//
//  Created by Breno Aquino on 18/07/23.
//

import DesignSystem
import SwiftUI
import Domain

private enum Constants {

    static let estimatedUnitSize: CGFloat = 120
    static let shadowOpacity: CGFloat = 0.2
}

public struct WidgetEditView<ViewModel: WidgetEditViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Localizable.description.text
                .foregroundColor(DSColor.secondaryLabel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.callout)
                .padding(.horizontal, space: .horizontal)

            TextField(
                Localizable.widgetName.value,
                text: $viewModel.widgetTitle,
                axis: .vertical
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.center)
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, space: .bigS)
            .padding(.horizontal, space: .bigM)

            TabView(selection: $viewModel.selectedViewID) {
                switch viewModel.entity {
                case let light as LightEntity:
                    allWidgetViews { lightWidgets(light, viewID: $0) }
                case let fan as FanEntity:
                    allWidgetViews { fanWidgets(fan, viewID: $0) }
                default:
                    EmptyView()
                }
            }

            editButton
        }
        .toast(data: $viewModel.toastData)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationTitle(viewModel.entity.domain.rawValue.capitalized)
        .toolbar {
            closeButton
        }
    }

    private func allWidgetViews<T: View>(
        @ViewBuilder element: @escaping (_ id: String) -> T
    ) -> some View {
        ForEach(viewModel.viewIDs, id: \.self) { widgetViewID in
            element(widgetViewID)
        }
    }

    private var closeButton: some View {
        Button(action: viewModel.close) {
            SystemImages.close
                .imageScale(.large)
                .foregroundColor(DSColor.label)
        }
        .foregroundColor(DSColor.label)
    }

    private var editButton: some View {
        Button(action: viewModel.updateWidget) {
            Localizable.update.text
        }
        .buttonStyle(DefaultMaterialButtonStyle(
            foregroundColor: DSColor.label,
            material: .thinMaterial
        ))
        .shadow(radius: .easy, color: .black.opacity(Constants.shadowOpacity))
    }

    @ViewBuilder
    private func lightWidgets(_ lightEntity: LightEntity, viewID: String) -> some View {
        switch viewID {
        case LightWidgetView.uniqueID:
            LightWidgetView(
                lightEntity: lightEntity,
                updateState: { _, _ in }
            )
            .setupSizeAndTag(unitSize: Constants.estimatedUnitSize)

        default:
            UnsupportedWidgetView(entity: lightEntity)
                .setupSizeAndTag(unitSize: Constants.estimatedUnitSize)
        }
    }

    @ViewBuilder
    private func fanWidgets(_ fanEntity: FanEntity, viewID: String) -> some View {
        switch viewID {
        case FanWidgetView.uniqueID:
            FanWidgetView(
                fanEntity: fanEntity,
                updateState: { _, _ in }
            )
            .setupSizeAndTag(unitSize: Constants.estimatedUnitSize)

        case FanSliderWidgetView.uniqueID:
            FanSliderWidgetView(
                fanEntity: fanEntity,
                percentage: .constant(0.2),
                updateState: { _, _ in }
            )
            .setupSizeAndTag(unitSize: Constants.estimatedUnitSize)

        default:
            UnsupportedWidgetView(entity: fanEntity)
                .setupSizeAndTag(unitSize: Constants.estimatedUnitSize)
        }
    }
}

#if DEBUG
import Domain

struct WidgetEditView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            WidgetEditView(viewModel: WidgetEditViewModelPreview(
                entity: LightEntity(id: "1", name: "Bedroom's Left Desk Support Light ", state: .on)
            ))
        }

        NavigationStack {
            WidgetEditView(viewModel: WidgetEditViewModelPreview(
                entity: FanEntity(
                    id: "1",
                    name: "Bedroom's Fan",
                    percentageStep: 0.2,
                    percentage: 0.2,
                    state: .on
                )
            ))
        }
    }
}
#endif
