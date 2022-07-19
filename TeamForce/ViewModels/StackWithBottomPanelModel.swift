//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

final class StackWithBottomPanelModel: BaseViewModel<UIStackView> {
    let topStackModel = StackModel(.axis(.vertical),
                                   .alignment(.fill),
                                   .distribution(.fill))
    let bottomStackModel = StackModel(.axis(.vertical),
                                      .alignment(.fill),
                                      .distribution(.fillEqually),
                                      .spacing(12))

    override func start() {
        set(.axis(.vertical))
        set(.alignment(.fill))
        set(.distribution(.fill))
        set(.models([
            topStackModel,
            bottomStackModel
        ]))
    }
}

extension StackWithBottomPanelModel: Stateable {}
