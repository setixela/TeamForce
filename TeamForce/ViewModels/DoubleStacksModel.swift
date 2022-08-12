//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

final class DoubleStacksModel: BaseViewModel<UIStackView> {
    let topStackModel = StackModel(.axis(.vertical),
                                   .alignment(.fill),
                                   .distribution(.fill))
    let bottomStackModel = StackModel(.axis(.vertical),
                                      .alignment(.fill),
                                      .distribution(.fillEqually))

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

extension DoubleStacksModel: Stateable {
   typealias State = StackState
}
