//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit
import ReactiveWorks
import Anchorage

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

final class ButtonModel: BaseViewModel<ButtonExtended> {
   //
   var eventsStore: ButtonEvents = .init()

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
   func applyState(_ state: ButtonState) {
      switch state {
      case .enabled(let value):
         view.isEnabled = value
      case .selected(let value):
         view.isSelected = value
      case .title(let title):
         view.setTitle(title, for: .normal)
      case .textColor(let color):
         view.setTitleColor(color, for: .normal)
      case .backColor(let color):
         view.backgroundColor = color
      case .cornerRadius(let radius):
         view.layer.cornerRadius = radius
      case .height(let height):
         view.addAnchors.constHeight(height)
      case .font(let font):
         view.titleLabel?.font = font
      case .image(let image):
         view.setImage(image, for: .normal)
      case .tint(let value):
         view.tintColor = value
         view.imageView?.tintColor = value
      case .vertical(let value):
         view.isVertical = value
      case .hidden(let value):
         view.isHidden = value
      }
   }
}

extension ButtonModel: Communicable {}

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
