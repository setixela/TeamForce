//
//  LabelCellModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 20.07.2022.
//

import UIKit
import ReactiveWorks

enum LabelCellState {
    case text(String)
}

final class LabelCellModel: BaseViewModel<UIStackView> {
    let label = LabelModel()

    required init() {
        super.init(isAutoreleaseView: true)
    }

    override func start() {
        view.backgroundColor = .init(hue: .random(in: 0.0 ... 1.0), saturation: 0.5, brightness: 0.85, alpha: 1)
        set(.models([label]))
        set(.height(44))
    }
}

extension LabelCellModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: LabelCellState) {
        switch state {
        case .text(let string):
            label.set(.text(string))
        }
    }
}
