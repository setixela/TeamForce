//
//  IconLabelHorizontalModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 01.07.2022.
//

import UIKit

enum IconLabelState {
    case icon(UIImage)
    case text(String)
}

final class IconLabelHorizontalModel<Asset: AssetProtocol>: BaseViewModel<UIStackView>,
    Assetable
{
    let label = Design.label.body2
    let icon = ImageViewModel()

    required init() {
        super.init()
    }

    override func start() {
        set(.axis(.horizontal))
        set(.distribution(.fill))
        set(.alignment(.center))
        set(.models([
            icon,
            Spacer(size: 20),
            label,
            Spacer()
        ]))
    }
}

extension IconLabelHorizontalModel: Stateable2 {
    typealias State = StackState

    func applyState(_ state: IconLabelState) {
        switch state {
        case .icon(let uIImage):
            icon.set(.image(uIImage))
        case .text(let string):
            label.set(.text(string))
        }
    }
}
