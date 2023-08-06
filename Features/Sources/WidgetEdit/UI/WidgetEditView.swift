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
        VStack {
            TabView {
                switch viewModel.entity {
                case let light as LightEntity:
                    lightWidgets(light)
                case let fan as FanEntity:
                    fanWidgets(fan)
                default:
                    EmptyView()
                }
            }

            editButton
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationTitle(viewModel.entity.name)
        .toolbar {
            closeButton
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
        Button(action: {}) {
            Localizable.update.text
        }
        .buttonStyle(DefaultMaterialButtonStyle(
            foregroundColor: DSColor.label,
            material: .thinMaterial
        ))
        .shadow(radius: .easy, color: .black.opacity(Constants.shadowOpacity))
    }

    @ViewBuilder
    private func lightWidgets(_ lightEntity: LightEntity) -> some View {
        LightWidgetView(
            lightEntity: lightEntity,
            updateState: { _, _ in }
        )
        .frame(width: Constants.estimatedUnitSize * CGFloat(LightWidgetView.units.columns))
        .frame(height: Constants.estimatedUnitSize * CGFloat(LightWidgetView.units.rows))
    }

    @ViewBuilder
    private func fanWidgets(_ fanEntity: FanEntity) -> some View {
        FanWidgetView(
            fanEntity: fanEntity,
            updateState: { _, _ in }
        )
        .frame(width: Constants.estimatedUnitSize * CGFloat(FanWidgetView.units.columns))
        .frame(height: Constants.estimatedUnitSize * CGFloat(FanWidgetView.units.rows))

        FanSliderWidgetView(
            fanEntity: fanEntity,
            percentage: .constant(0.2),
            updateState: { _, _ in }
        )
        .frame(width: Constants.estimatedUnitSize * CGFloat(FanSliderWidgetView.units.columns))
        .frame(height: Constants.estimatedUnitSize * CGFloat(FanSliderWidgetView.units.rows))
    }
}

#if DEBUG
import Domain

struct WidgetEditView_Preview: PreviewProvider {

    static var previews: some View {
        NavigationStack {
            WidgetEditView(viewModel: WidgetEditViewModelPreview(
                entity: LightEntity(id: "1", name: "Light", state: .on)
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
