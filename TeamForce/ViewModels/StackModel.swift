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
    var state: StackState?

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
    typealias State = StackState

    func setState(_ state: StackState) {
        view.axis = state.axis ?? view.axis
        view.spacing = state.spacing ?? view.spacing
        view.distribution = state.distribution ?? view.distribution
        view.alignment = state.alignment ?? view.alignment
    }
}

extension StackModel: Communicable {
    typealias Events = StackEvents
}

final class StackState: BaseClass {
    var distribution: UIStackView.Distribution?
    var axis: NSLayoutConstraint.Axis?
    var spacing: CGFloat?
    var alignment: UIStackView.Alignment?

    @discardableResult func setAxis(_ value: NSLayoutConstraint.Axis) -> Self {
        axis = value
        return self
    }

    @discardableResult func setSpacing(_ value: CGFloat) -> Self {
        spacing = value
        return self
    }

    @discardableResult func setAlignment(_ value: UIStackView.Alignment) -> Self {
        alignment = value
        return self
    }

    @discardableResult func setDistribution(_ value: UIStackView.Distribution) -> Self {
        distribution = value
        return self
    }
}
