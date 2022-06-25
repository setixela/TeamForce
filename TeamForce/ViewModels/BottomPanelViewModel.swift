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
    func applyState(_ state: StackState) {
        switch state {
        case .distribution(let value):
            view.distribution = value
        case .axis(let value):
            view.axis = value
        case .spacing(let value):
            view.spacing = value
        case .alignment(let value):
            view.alignment = value
        case .padding(let value):
            view.layoutMargins = value
            view.isLayoutMarginsRelativeArrangement = true
        }
    }
}
