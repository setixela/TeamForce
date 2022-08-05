//
//  Spacer.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit
import ReactiveWorks

final class Spacer: BaseViewModel<SpacerView> {
    convenience init(size: CGFloat = .zero) {
        self.init()

        if size != 0 {
            view.addAnchors
                .constWidth(size)
                .constHeight(size)
        }
    }

    override func start() {}
}

final class SpacerView: UIView {
    convenience init(size: CGFloat = .zero) {
        self.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        if size != 0 {
            addAnchors
                .constWidth(size)
                .constHeight(size)
        }
        backgroundColor = .none
        isAccessibilityElement = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(size: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

extension UIStackView {
    func addViewModels(_ models: UIViewModel...) {
        models.forEach { model in
            self.addArrangedSubview(model.uiView)
        }
    }
}
