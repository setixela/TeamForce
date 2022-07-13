//
//  BottomPanelViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - BottomPanelViewModel

enum BottomPanelState {
    case viewModel(UIViewModel)
    case viewModels([UIViewModel])
}

final class BottomPanelViewModel: BaseViewModel<UIStackView> {
    //

    override func start() {
        //
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 12
       // view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
       // view.isLayoutMarginsRelativeArrangement = true
    }
}

extension BottomPanelViewModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: BottomPanelState) {
        switch state {
        case .viewModel(let model):
            view.addArrangedSubview(model.uiView)
           // view.setNeedsLayout()
        case .viewModels(let models):
            models.forEach {
                view.addArrangedSubview($0.uiView)
            }
            //view.setNeedsLayout()
        }
    }
}
