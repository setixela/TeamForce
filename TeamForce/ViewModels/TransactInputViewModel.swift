//
//  TransactInputViewModel.swift
//  TeamForce
//
//  Created by Yerzhan Gapurinov on 29.07.2022.
//

import UIKit
import ReactiveWorks

enum TransactInputState {
    case leftCaptionText(String)
    case rightCaptionText(String)
}

final class TransactInputViewModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Designable
{
    private lazy var doubleLabel = DoubleLabelModel<Design>()

    internal lazy var textField = TextFieldModel()
        .set(.clearButtonMode(.never))
        .set(.font(Design.font.headline2))
        .set(.height(72))
        .set(.placeholder("0"))
        .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))
        .set(.backColor(Design.color.background2))

    override func start() {
        set(.alignment(.fill),
            .distribution(.fill),
            .axis(.vertical),
            .spacing(0),
            .height(118),
            .backColor(Design.color.background2),
            .models([
                doubleLabel,
                textField,
            ]))
    }
}

extension TransactInputViewModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: TransactInputState) {
        switch state {
        case .leftCaptionText(let string):
            doubleLabel.labelLeft.set(.text(string))
        case .rightCaptionText(let string):
            doubleLabel.labelRight.set(.text(string))
        }
    }
}
