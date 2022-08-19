//
//  StackWithBottomPanelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit
import ReactiveWorks

final class DoubleStacksModel: BaseViewModel<StackViewExtended> {
    let topStackModel = StackModel(.axis(.vertical),
                                   .alignment(.fill),
                                   .distribution(.fill))
    let bottomStackModel = StackModel(.axis(.vertical),
                                      .alignment(.fill),
                                      .distribution(.fill))

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

extension DoubleStacksModel: Stateable2 {
   typealias State = StackState
   typealias State2 = ViewState
}
