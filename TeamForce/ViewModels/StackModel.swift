//
//  StackModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit

struct StackEvents: InitProtocol {
    var addViewModel: Event<UIViewModel>?
    var addViewModels: Event<[UIViewModel]>?
}

final class StackModel: BaseViewModel<UIStackView> {
    var eventsStore: StackEvents = .init()
    var state: StackState = .init()

    override func start() {
        weak var wS = self

        onEvent(\.addViewModel) {
            wS?.view.addArrangedSubview($0.uiView)
        }
        .onEvent(\.addViewModels) {
            $0.forEach {
                wS?.view.addArrangedSubview($0.uiView)
            }
        }
    }
}

extension StackModel: Stateable {
    func applyState() {
        setupView {
           $0.axis = state.axis ?? view.axis
           $0.spacing = state.spacing ?? view.spacing
           $0.distribution = state.distribution ?? view.distribution
           $0.alignment = state.alignment ?? view.alignment
           $0.layoutMargins = state.padding ?? view.layoutMargins
           $0.isLayoutMarginsRelativeArrangement = true
        }
    }
}

extension StackModel: Communicable {
    typealias Events = StackEvents
}

final class StackState: BaseClass, Setable {
    var distribution: UIStackView.Distribution?
    var axis: NSLayoutConstraint.Axis?
    var spacing: CGFloat?
    var alignment: UIStackView.Alignment?
    var padding: UIEdgeInsets?
}
