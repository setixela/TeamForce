//
//  IconLabelHorizontalModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit

final class IconLabelHorizontalModel<Design: DesignProtocol>: BaseViewModel<UIStackView>,
    Communicable,
    Stateable,
    Designable
{
    var eventsStore: LabelIconEvent = .init()

    lazy var label = Design.label.body2
    lazy var icon = ImageViewModel()

    required init() {
        super.init()
    }

    override func start() {
        set(.axis(.horizontal))
            .set(.cornerRadius(Design.Parameters.cornerRadius))
            .set(.distribution(.fill))
            .set(.alignment(.fill))
            .set(.models([
                icon,
                Spacer(size: 20),
                label,
                Spacer()
            ]))

        weak var weakSelf = self
        onEvent(\.setText) {
            weakSelf?.label.set(.text($0))
        }
        .onEvent(\.setImage) {
            weakSelf?.icon.set(.image($0))
        }
    }
}
