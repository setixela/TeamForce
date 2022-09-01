//
//  Switcher.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.08.2022.
//

import ReactiveWorks
import UIKit

struct SwitchEvent: InitProtocol {
   var turnedOn: Event<Void>?
   var turnedOff: Event<Void>?
}

enum SwitcherState {
   case turnOn
   case turnOff
}

final class Switcher: BaseViewModel<UISwitch>, Communicable, Stateable2 {
   typealias State = ViewState
   typealias State2 = SwitcherState

   var events = SwitchEvent()

   override func start() {
      view.addTarget(self, action: #selector(didSwitch), for: .valueChanged)
   }

   @objc private func didSwitch() {
      if view.isOn {
         sendEvent(\.turnedOn)
      } else {
         sendEvent(\.turnedOff)
      }
   }
}

extension Switcher {
   func applyState(_ state: SwitcherState) {
      switch state {
      case .turnOn:
         view.setOn(true, animated: true)
      case .turnOff:
         view.setOn(false, animated: true)
      }
   }
}
