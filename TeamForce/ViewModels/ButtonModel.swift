//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

struct ButtonEvents: InitProtocol {
    var didTap: Event<Void>?
}

final class ButtonModel: BaseViewModel<UIButton> {
    var state: ButtonState = .init()
    var eventsStore: ButtonEvents = .init()

    override func start() {
        view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @objc func didTap() {
        print(state.state)
        if state.state == .normal {
            sendEvent(\.didTap)
        }
    }
}

extension ButtonModel: Communicable {}

extension ButtonModel: Stateable {
    func applyState() {

        view.backgroundColor = state.backColor ?? view.backgroundColor
        view.setTitle(state.title ?? view.title(for: .normal),
                      for: .normal)
        view.layer.cornerRadius = state.cornerRadius ?? view.layer.cornerRadius
        if let height = state.height {
            view.addAnchors.constHeight(height)
        }
        if let color = state.textColor {
            view.setTitleColor(color, for: .normal)
        }
    }
}

final class ButtonState: BaseClass, Setable {
    enum State {
        case normal
        case inactive
    }

    var state: State? {
        didSet {
            print("new state: ", state)
        }
    }
    var title: String?
    var textColor: UIColor?
    var backColor: UIColor?
    var cornerRadius: CGFloat?
    var height: CGFloat?
}
