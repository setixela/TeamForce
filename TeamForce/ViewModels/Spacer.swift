//
//  Spacer.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 21.06.2022.
//

import UIKit
import ReactiveWorks
import Anchorage

enum Grid: CGFloat {
   case x1 = 1
   case x2 = 2
   case x4 = 4
   case x8 = 8
   case x12 = 12
   case x16 = 16
   case x24 = 24
   case x32 = 32
   case x36 = 36
   case x48 = 48
   case x64 = 64

   // case infinity
   case xxx = 0
}

extension Grid {
   var spacer: Spacer {
      Spacer(value)
   }

   var value: CGFloat {
      CGFloat(rawValue)
   }
}

final class Spacer: BaseViewModel<SpacerView> {
    convenience init(_ size: CGFloat = .zero) {
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
    convenience init(_ size: CGFloat = .zero) {
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
        self.init(.zero)
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
