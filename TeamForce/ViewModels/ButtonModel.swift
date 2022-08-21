//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

protocol ButtonModelProtocol: UIViewModel, InitProtocol, Communicable where Events == ButtonEvents {
}

struct ButtonEvents: InitProtocol {
   var didTap: Event<Void>?
}

class ButtonModel: BaseViewModel<ButtonExtended>, ButtonModelProtocol {
   //
   var eventsStore: ButtonEvents = .init()
   var modes: Mode = .init()

   override func start() {
      view.addTarget(self, action: #selector(self.didTap), for: .touchUpInside)
   }

   @objc func didTap() {
      if view.isEnabled {
         sendEvent(\.didTap)
         print("Did tap")
         let frame = view.frame
         view.frame = view.frame.inset(by: .init(top: 3, left: 1, bottom: -2, right: 1))
         UIView.animate(withDuration: 0.2) {
            self.view.frame = frame
         }
      }
   }
}

extension ButtonModel: Stateable {
   typealias State = ButtonState
}

extension ButtonModel: Communicable {}

extension ButtonModel: Modable {
   struct Mode: WeakSelfied {
      typealias WeakSelf = ButtonModel

      var normal: Event<WeakSelf?>?
      var inactive: Event<WeakSelf?>?
   }
}

// MARK: - ButtonExtended(UIButton)

final class ButtonExtended: UIButton {
   var isVertical = false

   override func layoutSubviews() {
      super.layoutSubviews()

      if self.isVertical {
         //  self.contentHorizontalAlignment = .center
         self.setButtonVertical()
      }
   }

   private func setButtonVertical() {
      let titleSize = self.titleLabel?.frame.size ?? .zero
      let imageSize = self.imageView?.frame.size ?? .zero
      let spacing: CGFloat = 6.0
      self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
      self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
   }

//   override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//      return bounds.insetBy(dx: -10, dy: -10).contains(point)
//   }

   // or so: button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
}
