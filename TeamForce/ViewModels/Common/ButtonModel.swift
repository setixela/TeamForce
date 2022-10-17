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
   var didSelect: String?
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

         animateTap(uiView: uiView)
      }
   }
}

extension ButtonModel: Stateable {
   typealias State = ButtonState
}

extension ButtonModel: Eventable, ButtonTapAnimator {}

class ModableButton: ButtonModel, Modable {
   var modes: ButtonMode = .init()
}

class ButtonSelfModable: ButtonModel, SelfModable {
   var selfMode: SelfMode = .init()

   struct SelfMode: WeakSelfied {
      typealias WeakSelf = ButtonSelfModable

      var normal: Event<WeakSelf?>?
      var inactive: Event<WeakSelf?>?
   }
}
