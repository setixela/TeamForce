//
//  DoubleLabelPairModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit

struct DoubleLabelEvent: InitProtocol {
    var setLeftText: Event<String>?
    var setRightText: Event<String>?
}

final class DoubleLabelPairModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Stateable,
    Designable
{
    lazy var doubleLabelLeft = DoubleLabelModel<Design>()
    lazy var doubleLabelRight = DoubleLabelModel<Design>()

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
