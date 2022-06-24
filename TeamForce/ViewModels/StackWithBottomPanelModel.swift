//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

struct StackWithBottomPanelEvents: InitProtocol {
    var addViewModel: Event<UIViewModel>?
    var addViewModels: Event<[UIViewModel]>?
    var addBottomPanelModel: Event<UIViewModel>?
}

final class StackWithBottomPanelModel: BaseViewModel<UIStackView> {
    var eventsStore: StackWithBottomPanelEvents = .init()

    let stackModel = StackModel(state: DesignSystem.State.mainView.default)
    let bottomModel = BottomPanelViewModel()

    override func start() {
        configure()

        weak var wS = self

        onEvent(\.addViewModel) {
            wS?.stackModel.sendEvent(\.addViewModel, payload: $0)
        }
        .onEvent(\.addViewModels) {
            wS?.stackModel.sendEvent(\.addViewModels, payload: $0)
        }
        .onEvent(\.addBottomPanelModel) {
            wS?.bottomModel.sendEvent(\.addModel, payload: $0)
        }
    }

    private func configure() {
        setupView {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill

            $0.addArrangedSubview(stackModel.uiView)
            $0.addArrangedSubview(bottomModel.uiView)
        }
    }
}

extension StackWithBottomPanelModel: Communicable {}
