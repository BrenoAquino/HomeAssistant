//
//  WidgetUISelectionView.swift
//  
//
//  Created by Breno Aquino on 09/08/23.
//

import Domain
import DesignSystem
import SwiftUI

private enum Constants {

    static let estimatedUnitSize: CGFloat = 120
}

struct WidgetUISelectionView<ViewModel: WidgetUISelectionViewModel>: View {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }

    private func allWidgetViews<T: View>(
        @ViewBuilder element: @escaping (_ id: String) -> T
    ) -> some View {
        ForEach(viewModel.viewIDs, id: \.self) { widgetViewID in
            element(widgetViewID)
        }
    }

    private var editButton: some View {
        Button(action: viewModel.createOrUpdateWidget) {
            Localizable.update.text
        }
        .buttonStyle(DefaultMaterialButtonStyle(
            foregroundColor: DSColor.label,
            material: .thinMaterial
        ))
        .shadow(radius: .normal)
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
import Preview

struct WidgetUISelectionView_Preview: PreviewProvider {

    static var previews: some View {
        WidgetUISelectionView(viewModel: WidgetUISelectionViewModelPreview())
    }
}
#endif
