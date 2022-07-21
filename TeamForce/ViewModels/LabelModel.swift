//
//  LabelModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

final class LabelModel: BaseViewModel<PaddingLabel> {}

extension LabelModel: Stateable {
    func applyState(_ state: LabelState) {
        switch state {
        case .text(let value):
            view.text = value
        case .font(let value):
            view.font = value
        case .color(let value):
            view.textColor = value
        case .numberOfLines(let value):
            view.numberOfLines = value
        case .alignment(let value):
            view.textAlignment = value
        case .padding(let value):
            view.padding = value
        }
    }
}

extension LabelModel: Stateable2 {
    typealias State2 = ViewState
}

enum LabelState {
    case text(String)
    case font(UIFont)
    case color(UIColor)
    case numberOfLines(Int)
    case alignment(NSTextAlignment)
    case padding(UIEdgeInsets)
}
