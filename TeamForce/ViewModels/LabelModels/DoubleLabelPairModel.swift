//
//  DoubleLabelPairModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit
import ReactiveWorks

enum DoubleLabelPairState {
    case leftPair(text1: String, text2: String)
    case rightPair(text1: String, text2: String)
}

final class DoubleLabelPairModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Designable
{

    let doubleLabelLeft = DoubleLabelModel<Design>()
    let doubleLabelRight = DoubleLabelModel<Design>()

    typealias State = StackState

    override func start() {
        set(.axis(.horizontal))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.distribution(.fillProportionally))
            .set(.alignment(.fill))
            .set(.models([
                doubleLabelLeft,
                doubleLabelRight
            ]))

    }
}

extension DoubleLabelPairModel: Stateable2 {

   func applyState(_ state: DoubleLabelPairState) {
        switch state {
        case .leftPair(text1: let text1, text2: let text2):
            doubleLabelLeft.labelLeft.set(.text(text1))
            doubleLabelLeft.labelRight.set(.text(text2))
        case .rightPair(text1: let text1, text2: let text2):
            doubleLabelRight.labelLeft.set(.text(text1))
            doubleLabelRight.labelRight.set(.text(text2))
        }
    }
}
