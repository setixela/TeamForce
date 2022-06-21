//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

final class LabelModel: BaseViewModel<PaddingLabel> {
    var state: State?
}

extension LabelModel: Stateable {
    func setState(_ state: LabelState) {
        view.text = state.text ?? view.text
        view.font = state.font ?? view.font
        view.textColor = state.color ?? view.textColor
        view.textAlignment = state.alignment ?? view.textAlignment
        view.numberOfLines = state.numberOfLines ?? view.numberOfLines
        view.padding = state.padding ?? view.padding
        view.backgroundColor = .cyan
    }

    typealias State = LabelState
}

final class LabelState: BaseClass {
    var text: String?
    var font: UIFont?
    var color: UIColor?
    var numberOfLines: Int?
    var alignment: NSTextAlignment?
    var padding: UIEdgeInsets?

    @discardableResult func setText(_ value: String) -> Self {
        text = value
        return self
    }

    @discardableResult func setFont(_ value: UIFont) -> Self {
        font = value
        return self
    }

    @discardableResult func setColor(_ value: UIColor) -> Self {
        color = value
        return self
    }

    @discardableResult func setAlignment(_ value: NSTextAlignment) -> Self {
        alignment = value
        return self
    }

    @discardableResult func setNumberOfLines(_ value: Int) -> Self {
        numberOfLines = value
        return self
    }

    @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
        padding = value
        return self
    }
}

