//
//  ButtonModel.swift
//  TeamForce
//
//  Created by Aleksandr Solovyev on 22.06.2022.
//

import UIKit

enum ButtonState {
   enum State {
      case normal
      case selected
      case inactive
   }

   case state(State)
   case title(String)
   case textColor(UIColor)
   case backColor(UIColor)
   case cornerRadius(CGFloat)
   case height(CGFloat)
}

struct ButtonEvents: InitProtocol {
   var didTap: Event<Void>?
}

final class ButtonModel: BaseViewModel<UIButton> {
   //
   var eventsStore: ButtonEvents = .init()

   private var state: ButtonState.State = .normal

   override func start() {
      view.addTarget(self, action: #selector(didTap), for: .touchUpInside)
   }

   @objc func didTap() {
      if state == .normal {
         sendEvent(\.didTap)
      }
   }

   private var count = 0
}

extension ButtonModel: Communicable {}

extension ButtonModel: Stateable {
   func applyState(_ state: ButtonState) {
      switch state {
      case .state(let state):
         self.state = state
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
      }
   }
}
