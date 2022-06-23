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
