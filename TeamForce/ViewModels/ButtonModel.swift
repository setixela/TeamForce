//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

enum ButtonState: KeyPathSetable {
   case enabled(Bool)
   case selected(Bool)
   case title(String)
   case textColor(UIColor)
   case font(UIFont)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case height(CGFloat)
   case image(UIImage)
   case tint(UIColor)
   case vertical(Bool)
   case hidden(Bool)
}

struct ButtonEvents: InitProtocol {
   var didTap: Event<Void>?
}


class ButtonModel: BaseViewModel<ButtonExtended> {
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
}
