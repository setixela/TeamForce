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

final class TransactInputViewModel<Design: DesignProtocol>: BaseViewModel<StackViewExtended>,
    Designable, Stateable
{
   typealias State = StackState

   lazy var textField = TextFieldModel<Design>()
        .set(.clearButtonMode(.never))
        .set(.font(Design.font.headline2))
        .set(.height(72))
        .set(.placeholder("0"))
        .set(.padding(.init(top: 0, left: 16, bottom: 0, right: 16)))
        .set(.backColor(Design.color.backgroundSecondary))

    override func start() {
        set(.alignment(.fill),
            .distribution(.fill),
            .axis(.vertical),
            .spacing(0),
            .height(118),
            .backColor(Design.color.backgroundSecondary),
            .models([
                textField,
            ]))
    }
}

final class Small {}
