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

