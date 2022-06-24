//
//  BottomPanelViewModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 24.06.2022.
//

import UIKit

// MARK: - BottomPanelViewModel

struct BottomPanelEvents: InitProtocol {
    var addModel: Event<UIViewModel>?
    var addModels: Event<[UIViewModel]>?
}

final class BottomPanelViewModel: BaseViewModel<UIStackView> {
    var eventsStore: BottomPanelEvents = .init()
    var state: StackState = .init()

    override func start() {
        configure()

        onEvent(\.addModel) { [weak self] in
            let view = $0.uiView
            self?.view.addArrangedSubview(view)
            self?.view.setNeedsLayout()
        }
        .onEvent(\.addModels) { [weak self] in
            $0.forEach {
                self?.view.addArrangedSubview($0.uiView)
            }
        }
    }

    private func configure() {
        setupView {
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .vertical
            $0.spacing = 12
            $0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 48, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.backgroundColor = .lightGray
        }
    }
}

extension BottomPanelViewModel: Communicable {}

extension BottomPanelViewModel: Stateable {
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

    typealias State = StackState
}
