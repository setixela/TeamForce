//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

enum StackWithBottomPanelState {
    case topModels([UIViewModel])
    case bottomModels([UIViewModel])
}

final class StackWithBottomPanelModel: BaseViewModel<UIStackView> {
    let stackModel = StackModel(.axis(.vertical),
                                .alignment(.fill),
                                .distribution(.fill))
    let bottomModel = BottomPanelViewModel()

    override func start() {
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill

        view.addArrangedSubview(stackModel.uiView)
        view.addArrangedSubview(bottomModel.uiView)
    }
}

extension StackWithBottomPanelModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: StackWithBottomPanelState) {
        switch state {
        case .topModels(let viewModels):
            stackModel.set(.models(viewModels))
        case .bottomModels(let viewModels):
            bottomModel.set(.models(viewModels))
        }
    }
}
