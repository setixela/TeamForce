//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import Anchorage
import ReactiveWorks
import UIKit

protocol ButtonModelProtocol: UIViewModel, InitProtocol, Eventable where Events == ButtonEvents {}

struct ButtonEvents: InitProtocol {
   var didTap: Void?
}

class ButtonModel: BaseViewModel<ButtonExtended>, ButtonModelProtocol {
   //

   typealias Events = ButtonEvents
   var events = [Int: LambdaProtocol?]()

   override func start() {
      view.addTarget(self, action: #selector(self.didTap), for: .touchUpInside)
   }

   @objc func didTap() {
      if view.isEnabled {
         send(\.didTap)
         print("Did tap")

         animateTap()
      }
   }
}

extension ButtonModel: Stateable {
   typealias State = ButtonState
}

extension ButtonModel: Eventable, ButtonTapAnimator {}

class ButtonModelModableOld: ButtonModel, SelfModable {

   var modes: Mode = .init()

   struct Mode: WeakSelfied {
      typealias WeakSelf = ButtonModelModableOld

      var normal: Event<WeakSelf?>?
      var inactive: Event<WeakSelf?>?
   }
}

// MARK: - ButtonExtended(UIButton)

final class ButtonExtended: UIButton {
   var isVertical = false

   override init(frame: CGRect) {
      super.init(frame: frame)

      imageView?.contentMode = .scaleAspectFit
   }

   override func layoutSubviews() {
      super.layoutSubviews()

      if self.isVertical {
         //  self.contentHorizontalAlignment = .center
         self.setButtonVertical()
      }
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
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

protocol ButtonTapAnimator: UIViewModel {}

extension ButtonTapAnimator {
   func animateTap() {
      let frame = uiView.frame
      uiView.frame = uiView.frame.inset(by: .init(top: 3, left: 2, bottom: -2, right: 3))
      UIView.animate(withDuration: 0.3) {
         self.uiView.frame = frame
      }
   }

   func animateTapWithShadow() {
      let frame = uiView.frame
      uiView.frame = uiView.frame.inset(by: .init(top: 5, left: 2, bottom: -3, right: 3))
      let layer = uiView.layer
      let radius = layer.shadowRadius
      let color = layer.shadowColor
      let opacity = layer.shadowOpacity
      let masksToBounds = layer.masksToBounds
      let clipsToBounds = uiView.clipsToBounds
      layer.masksToBounds = false
      uiView.clipsToBounds = false
      layer.shadowOpacity = 0.15
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowRadius = 5
      UIView.animate(withDuration: 0.3) {
         self.uiView.frame = frame
         layer.shadowOpacity = opacity
         layer.shadowColor = color
         layer.shadowRadius = 100
         self.uiView.setNeedsDisplay()
      } completion: { _ in
         layer.shadowRadius = radius
         layer.masksToBounds = masksToBounds
         self.uiView.clipsToBounds = clipsToBounds
      }
   }
}
