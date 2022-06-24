//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

//protocol Paddingable {
//    var padding: UIEdgeInsets? { get set }
//}
//
//extension Paddingable {
//    @discardableResult func setPadding(_ value: UIEdgeInsets) -> Self {
//        padding = value
//        return self
//    }
//}

final class LabelModel: BaseViewModel<PaddingLabel> {
    var state: LabelState = .init()
}

extension LabelModel: Stateable {

    func applyState() {
        view.text = state.text ?? view.text
        view.font = state.font ?? view.font
        view.textColor = state.color ?? view.textColor
        view.textAlignment = state.alignment ?? view.textAlignment
        view.numberOfLines = state.numberOfLines ?? view.numberOfLines
        view.padding = state.padding ?? view.padding
        view.backgroundColor = .cyan.withAlphaComponent(0.1)
    }
}

final class LabelState: BaseState {
    var text: String?
    var font: UIFont?
    var color: UIColor?
    var numberOfLines: Int?
    var alignment: NSTextAlignment?
    var padding: UIEdgeInsets?
}

